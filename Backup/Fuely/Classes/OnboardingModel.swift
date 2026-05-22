//
//  OnboardingModel.swift
//  Fuely
//
//  Created by Jarrod Norwell on 27/9/2025.
//

import ColourKit
import CoreLocation
import FontKit
import OnboardingKit
import SwiftUI
import UIKit

class OnboardingModel : NSObject {
    var locationAccess: LocationAccess
    
    var controller: UIViewController? = nil
    
    override init() {
        locationAccess = .init()
        super.init()
        locationAccess.manager.delegate = self
    }
    
    func location(controller: UIViewController) async {
        var locationController: OBController {
            let image: UIImage? = UIImage(systemName: "location.fill")
            
            let textConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                           color: .label,
                                                                           font: UIFont.regular(from: .extraLargeTitle),
                                                                           text: "Location")
            
            let secondaryTextConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                                    color: .secondaryLabel,
                                                                                    font: UIFont.regular(from: .body),
                                                                                    text: "Fuely requires access to Location to provide details of fuel stations based on your current location")
            
            let buttons: [(UIButton.Configuration, @MainActor (UIViewController) async -> Void)] = [
                (UIButton.Configuration.glassConfiguration(.large, .capsule, nil, "Continue"), { controller in
                    self.controller = controller
                    self.locationAccess.authorise()
                })
            ]
            
            let configuration: OBControllerConfiguration = OBControllerConfiguration(image: image,
                                                                                     textConfiguration: textConfiguration,
                                                                                     secondaryConfiguration: secondaryTextConfiguration,
                                                                                     tertiaryConfiguration: nil,
                                                                                     buttons: buttons, colors: Colour.vibrantBlues)
            
            let obController: OBController = OBController(configuration: configuration)
            obController.modalPresentationStyle = .fullScreen
            return obController
        }
        
        controller.present(locationController, animated: true)
    }
    
    func settings(controller: UIViewController) async {
        var settingsController: OBController {
            let image: UIImage? = UIImage(systemName: "gearshape.fill")
            
            let textConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                           color: .label,
                                                                           font: UIFont.regular(from: .extraLargeTitle),
                                                                           text: "Access Denied")
            
            let secondaryTextConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                                    color: .secondaryLabel,
                                                                                    font: UIFont.regular(from: .body),
                                                                                    text: "Access to Location has been denied and Fuely cannot function without it. Please go to the Settings app to allow access")
            
            let buttons: [(UIButton.Configuration, @MainActor (UIViewController) async -> Void)] = [
                (UIButton.Configuration.glassConfiguration(.large, .capsule, nil, "Open Settings"), { controller in
                    guard let url: URL = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    
                    UIApplication.shared.open(url)
                })
            ]
            
            let configuration: OBControllerConfiguration = OBControllerConfiguration(image: image,
                                                                                     textConfiguration: textConfiguration,
                                                                                     secondaryConfiguration: secondaryTextConfiguration,
                                                                                     tertiaryConfiguration: nil,
                                                                                     buttons: buttons, colors: Colour.vibrantReds)
            
            let obController: OBController = OBController(configuration: configuration)
            obController.modalPresentationStyle = .fullScreen
            return obController
        }
        
        controller.present(settingsController, animated: true)
    }
}

extension OnboardingModel : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let result: Bool = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
        guard let controller else {
            return
        }
        
        UserDefaults.standard.set(result, forKey: "fuely.2.0.locationAccessGranted")
        UserDefaults.standard.set(true, forKey: "fuely.2.0.onboardingComplete")
        
        if result {
            let viewController: UINavigationController = .init(rootViewController: ViewController(collectionViewLayout: LayoutManager.main))
            viewController.modalPresentationStyle = .fullScreen
            controller.present(viewController, animated: true)
        } else {
            Task {
                await self.settings(controller: controller)
            }
        }
    }
}
