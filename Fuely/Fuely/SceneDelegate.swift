//
//  SceneDelegate.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import ColourKit
import FontKit
import OnboardingKit
import SwiftUI
import UIKit

class SceneDelegate : UIResponder, UIWindowSceneDelegate {
    var window: UIWindow? = nil

    var onboardingModel: OnboardingModel = OnboardingModel()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        // UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        onboardingModel.locationAccess.checkAuthorisationStatus()
        UserDefaults.standard.set(onboardingModel.locationAccess.authorised, forKey: "fuely.2.0.locationAccessGranted")
        
        let locationAccessGranted: Bool = onboardingModel.locationAccess.authorised
        let onboardingComplete: Bool = UserDefaults.standard.bool(forKey: "fuely.2.0.onboardingComplete")
        
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
                (UIButton.Configuration.configuration(.large, .capsule, nil, "Open Settings"), { controller in
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
            
            return OBController(configuration: configuration)
        }
        
        var onboardingController: OBController {
            let image: UIImage? = UIImage(systemName: "gauge.with.needle.fill")
            
            let textConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                           color: .label,
                                                                           font: UIFont.regular(from: .extraLargeTitle),
                                                                           text: "Fuely")
            
            let secondaryTextConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                                    color: .secondaryLabel,
                                                                                    font: UIFont.regular(from: .body),
                                                                                    text: "Latest fuel prices across Western Australia, updated every 24 hours")
            
            let tertiaryTextConfiguration: LabelConfiguration = LabelConfiguration(alignment: .center,
                                                                                   color: .tertiaryLabel,
                                                                                   font: UIFont.regular(from: .callout),
                                                                                   text: "Developed by Jarrod Norwell\nLicensed under GPLv3")
            
            let buttons: [(UIButton.Configuration, @MainActor (UIViewController) async -> Void)] = [
                (UIButton.Configuration.configuration(.large, .capsule, nil, "Continue"), { controller in
                    await self.onboardingModel.location(controller: controller)
                })
            ]
            
            let configuration: OBControllerConfiguration = OBControllerConfiguration(image: image,
                                                                                     textConfiguration: textConfiguration,
                                                                                     secondaryConfiguration: secondaryTextConfiguration,
                                                                                     tertiaryConfiguration: tertiaryTextConfiguration,
                                                                                     buttons: buttons, colors: [
                                                                                        Colour(red: 0.65, green: 0.90, blue: 0.95),
                                                                                        Colour(red: 0.50, green: 0.85, blue: 0.90),
                                                                                        Colour(red: 0.35, green: 0.80, blue: 0.85),
                                                                                        Colour(red: 0.25, green: 0.75, blue: 0.80),
                                                                                        Colour(red: 0.15, green: 0.70, blue: 0.75),
                                                                                        Colour(red: 0.10, green: 0.62, blue: 0.68),
                                                                                        Colour(red: 0.08, green: 0.54, blue: 0.60),
                                                                                        Colour(red: 0.05, green: 0.45, blue: 0.52),
                                                                                        Colour(red: 0.02, green: 0.36, blue: 0.44)
                                                                                    ])
            
            return OBController(configuration: configuration)
        }
        
        window = UIWindow(windowScene: windowScene)
        guard let window else {
            return
        }
        window.rootViewController = if locationAccessGranted && onboardingComplete {
            TabController()
        } else {
            if !locationAccessGranted && onboardingComplete {
                settingsController
            } else {
                onboardingController
            }
        }
        window.tintColor = .systemBlue
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
