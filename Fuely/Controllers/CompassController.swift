//
//  CompassController.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import ColourKit
import ConstraintKit
import CoreLocation
import FontKit
import MapKit
import OnboardingKit
import SwiftUI
import UIKit

extension UIView {
    var removeFromSuperview: Void {
        removeFromSuperview()
    }
}

extension UIViewController {
    func interfaceOrientation() -> UIInterfaceOrientation {
        guard let window = view.window, let windowScene = window.windowScene else {
            return switch UIDevice.current.orientation {
            case .portrait:
                .portrait
            case .landscapeLeft:
                .landscapeLeft
            case .landscapeRight:
                .landscapeRight
            default:
                .portrait
            }
        }
        
        return windowScene.effectiveGeometry.interfaceOrientation
    }
}

class CompassController : UIViewController {
    var distance: CLLocationDistance? = nil
    var manager: CLLocationManager = CLLocationManager()
    
    var station: API.Item? = nil
    
    var vibrancyVisualEffectView: UIVisualEffectView? = nil
    
    var imageView: UIImageView? = nil
    var containerView: UIView? = nil
    var label: UILabel? = nil,
        secondaryLabel: UILabel? = nil,
        tertiaryLabel: UILabel? = nil
    
    var leftContainerView: UIView? = nil,
        rightContainerView: UIView? = nil
    
    var constraints: (portrait: [NSLayoutConstraint], landscape: [NSLayoutConstraint]) = ([], [])
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let hostingController: UIHostingController = UIHostingController(rootView: MeshGradientView(colours: Colour.vibrantBlues))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.insertSubview(hostingController.view, belowSubview: view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.top.constraint(equalTo: view.top).isActive = true
        hostingController.view.left.constraint(equalTo: view.left).isActive = true
        hostingController.view.bottom.constraint(equalTo: view.bottom).isActive = true
        hostingController.view.right.constraint(equalTo: view.right).isActive = true
        
        let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualEffectView)
        
        visualEffectView.top.constraint(equalTo: view.top).isActive = true
        visualEffectView.left.constraint(equalTo: view.left).isActive = true
        visualEffectView.bottom.constraint(equalTo: view.bottom).isActive = true
        visualEffectView.right.constraint(equalTo: view.right).isActive = true
        
        vibrancyVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemMaterial)))
        guard let vibrancyVisualEffectView else {
            return
        }
        vibrancyVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vibrancyVisualEffectView)
        
        vibrancyVisualEffectView.top.constraint(equalTo: view.top).isActive = true
        vibrancyVisualEffectView.left.constraint(equalTo: view.left).isActive = true
        vibrancyVisualEffectView.bottom.constraint(equalTo: view.bottom).isActive = true
        vibrancyVisualEffectView.right.constraint(equalTo: view.right).isActive = true
        
        
        leftContainerView = UIView()
        guard let leftContainerView else {
            return
        }
        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyVisualEffectView.contentView.addSubview(leftContainerView)
        
        rightContainerView = UIView()
        guard let rightContainerView else {
            return
        }
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyVisualEffectView.contentView.addSubview(rightContainerView)
        
        
        imageView = UIImageView(image: UIImage(systemName: "arrow.up.circle.fill"))
        guard let imageView else {
            return
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        vibrancyVisualEffectView.contentView.addSubview(imageView)
        
        containerView = UIView()
        guard let containerView else {
            return
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyVisualEffectView.contentView.addSubview(containerView)
        
        tertiaryLabel = UILabel()
        guard let tertiaryLabel else {
            return
        }
        tertiaryLabel.translatesAutoresizingMaskIntoConstraints = false
        tertiaryLabel.font = UIFont.regular(from: .headline)
        tertiaryLabel.numberOfLines = 2
        tertiaryLabel.textAlignment = .center
        tertiaryLabel.textColor = .white
        vibrancyVisualEffectView.contentView.addSubview(tertiaryLabel)
        
        label = UILabel()
        guard let label else {
            return
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular(from: .extraLargeTitle)
        label.text = "Unknown Cardinal"
        label.textAlignment = .center
        label.textColor = .white
        containerView.addSubview(label)
        
        secondaryLabel = UILabel()
        guard let secondaryLabel else {
            return
        }
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = UIFont.regular(from: .headline)
        secondaryLabel.text = "Unknown Distance"
        secondaryLabel.textAlignment = .center
        secondaryLabel.textColor = .lightText
        containerView.addSubview(secondaryLabel)
        
        manager.delegate = self
        manager.headingFilter = 0
        manager.distanceFilter = 0
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraints.portrait.append(contentsOf: [])
            
            constraints.landscape.append(contentsOf: [])
        } else {
            constraints.portrait.append(contentsOf: [
                imageView.centerX.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerX),
                imageView.centerY.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerY),
                imageView.width.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.width, multiplier: 4.0 / 5.0),
                imageView.height.constraint(equalTo: imageView.salg.width),
                
                containerView.top.constraint(equalTo: imageView.salg.bottom, constant: 20),
                containerView.left.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.left, constant: 20),
                containerView.bottom.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.bottom, constant: -20),
                containerView.right.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.right, constant: -20),
                
                tertiaryLabel.centerX.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerX),
                tertiaryLabel.top.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.top, constant: 20),
                tertiaryLabel.left.constraint(greaterThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.left, constant: 20),
                tertiaryLabel.right.constraint(lessThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.right, constant: -20),
                
                label.centerX.constraint(equalTo: containerView.salg.centerX),
                label.bottom.constraint(equalTo: containerView.salg.centerY, constant: -4),
                label.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20),
                label.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20),
                
                secondaryLabel.centerX.constraint(equalTo: containerView.salg.centerX),
                secondaryLabel.top.constraint(equalTo: containerView.salg.centerY, constant: 4),
                secondaryLabel.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20),
                secondaryLabel.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20)
            ])
            
            constraints.landscape.append(contentsOf: [
                leftContainerView.top.constraint(equalTo: vibrancyVisualEffectView.contentView.top),
                leftContainerView.left.constraint(equalTo: vibrancyVisualEffectView.contentView.left),
                leftContainerView.bottom.constraint(equalTo: vibrancyVisualEffectView.contentView.bottom),
                leftContainerView.right.constraint(equalTo: vibrancyVisualEffectView.contentView.centerX),
                
                rightContainerView.top.constraint(equalTo: vibrancyVisualEffectView.contentView.top),
                rightContainerView.left.constraint(equalTo: vibrancyVisualEffectView.contentView.centerX),
                rightContainerView.bottom.constraint(equalTo: vibrancyVisualEffectView.contentView.bottom),
                rightContainerView.right.constraint(equalTo: vibrancyVisualEffectView.contentView.right),
                
                imageView.centerX.constraint(equalTo: leftContainerView.salg.centerX),
                imageView.centerY.constraint(equalTo: leftContainerView.centerY),
                imageView.width.constraint(equalTo: leftContainerView.salg.height, multiplier: 5.0 / 5.0),
                imageView.height.constraint(equalTo: imageView.salg.width),
                
                containerView.top.constraint(equalTo: rightContainerView.top),
                containerView.left.constraint(equalTo: rightContainerView.salg.left),
                containerView.bottom.constraint(equalTo: rightContainerView.bottom),
                containerView.right.constraint(equalTo: rightContainerView.salg.right),
                
                tertiaryLabel.centerX.constraint(equalTo: rightContainerView.salg.centerX),
                tertiaryLabel.top.constraint(equalTo: rightContainerView.salg.top, constant: 20),
                tertiaryLabel.left.constraint(greaterThanOrEqualTo: rightContainerView.salg.left, constant: 20),
                tertiaryLabel.right.constraint(lessThanOrEqualTo: rightContainerView.salg.right, constant: -20),
                
                label.centerX.constraint(equalTo: containerView.salg.centerX),
                label.bottom.constraint(equalTo: containerView.centerY, constant: -4),
                label.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20),
                label.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20),
                
                secondaryLabel.centerX.constraint(equalTo: containerView.salg.centerX),
                secondaryLabel.top.constraint(equalTo: containerView.centerY, constant: 4),
                secondaryLabel.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20),
                secondaryLabel.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20)
            ])
        }
        
        changeSubviewsForOrientation()
        changeConstraintsForOrientationChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let imageView, let label, let secondaryLabel, let tertiaryLabel else {
            return
        }
        
        if let tabBarController: TabController = tabBarController as? TabController {
            if let station: API.Item = tabBarController.selectedStation {
                self.station = station
                tertiaryLabel.text = station.tradingName
                
                manager.startUpdatingHeading()
                manager.startUpdatingLocation()
            } else {
                self.station = nil
                
                imageView.transform = CGAffineTransform.identity
                
                label.text = "Unknown Cardinal"
                secondaryLabel.text = "Unknown Distance"
                tertiaryLabel.text = "No Station Selected"
                
                manager.stopUpdatingHeading()
                manager.stopUpdatingLocation()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let imageView else {
            return
        }
        
        imageView.transform = .identity
        
        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
        
        coordinator.animate { context in } completion: { context in
            self.changeSubviewsForOrientation()
            self.changeConstraintsForOrientationChange()
            
            self.manager.startUpdatingHeading()
            self.manager.startUpdatingLocation()
        }
    }
    
    func changeConstraintsForOrientationChange() {
        var windowScene: UIWindowScene? = nil
        if let window: UIWindow = view.window, let currentWindowScene: UIWindowScene = window.windowScene {
            windowScene = currentWindowScene
        } else if let currentWindowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene = currentWindowScene
        } else {
            windowScene = nil
        }
        
        guard let windowScene: UIWindowScene else {
            return
        }
        
        switch windowScene.effectiveGeometry.interfaceOrientation {
        case .portrait:
            view.removeConstraints(constraints.landscape)
            view.addConstraints(constraints.portrait)
        case .landscapeLeft, .landscapeRight:
            view.removeConstraints(constraints.portrait)
            view.addConstraints(constraints.landscape)
        default:
            break
        }
    }
    
    func changeSubviewsForOrientation() {
        guard let vibrancyVisualEffectView: UIVisualEffectView else {
            return
        }
        
        guard let leftContainerView: UIView, let rightContainerView: UIView else {
            return
        }
        
        var windowScene: UIWindowScene? = nil
        if let window: UIWindow = view.window, let currentWindowScene: UIWindowScene = window.windowScene {
            windowScene = currentWindowScene
        } else if let currentWindowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene = currentWindowScene
        } else {
            windowScene = nil
        }
        
        guard let windowScene: UIWindowScene else {
            return
        }
        
        leftContainerView.subviews.forEach(\.removeFromSuperview)
        rightContainerView.subviews.forEach(\.removeFromSuperview)
        vibrancyVisualEffectView.contentView.subviews.forEach(\.removeFromSuperview)
        
        guard let imageView, let containerView, let label, let secondaryLabel, let tertiaryLabel else {
            return
        }
        
        if windowScene.effectiveGeometry.interfaceOrientation.isPortrait {
            vibrancyVisualEffectView.contentView.addSubview(imageView)
            vibrancyVisualEffectView.contentView.addSubview(containerView)
            containerView.addSubview(label)
            containerView.addSubview(secondaryLabel)
            vibrancyVisualEffectView.contentView.addSubview(tertiaryLabel)
        } else {
            vibrancyVisualEffectView.contentView.addSubview(leftContainerView)
            vibrancyVisualEffectView.contentView.addSubview(rightContainerView)
            
            leftContainerView.addSubview(imageView)
            rightContainerView.addSubview(containerView)
            containerView.addSubview(label)
            containerView.addSubview(secondaryLabel)
            rightContainerView.addSubview(tertiaryLabel)
        }
    }
}

extension CompassController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var windowScene: UIWindowScene? = nil
        if let window: UIWindow = view.window, let currentWindowScene: UIWindowScene = window.windowScene {
            windowScene = currentWindowScene
        } else if let currentWindowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene = currentWindowScene
        } else {
            windowScene = nil
        }
        
        guard let windowScene: UIWindowScene else {
            return
        }
        
        guard let station: API.Item else {
            return
        }
        
        guard let imageView: UIImageView, let label: UILabel, let location: CLLocation = manager.location else {
            return
        }
        
        let bearing: Double = location.coordinate.bearing(to: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude))
        let deviceHeading: CLLocationDirection = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        let orientationOffset: CLLocationDirection = {
            switch windowScene.effectiveGeometry.interfaceOrientation {
                case .portrait:
                    return 0
                case .landscapeLeft:
                    return -90
                case .landscapeRight:
                    return 90
                case .portraitUpsideDown:
                    return 180
                default:
                    return 0
                }
            }()
        
        let adjustedHeading = (deviceHeading + orientationOffset).normalizedDegrees
        let relativeBearing = (bearing - adjustedHeading).normalizedDegrees
        
        let radians: CGFloat = .init(relativeBearing * .pi / 180)
        
        label.text = location.coordinate.cardinal(from: relativeBearing)
        if let secondaryLabel, let distance {
            secondaryLabel.text = .init(format: "%.2f km", distance)
        }
        
        imageView.transform = .init(rotationAngle: radians)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let station: API.Item else {
            return
        }
        
        guard let location: CLLocation = locations.last else {
            return
        }
        
        let destination: CLLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
        
        let mapPoint1: MKMapPoint = MKMapPoint(location.coordinate)
        let mapPoint2: MKMapPoint = MKMapPoint(destination.coordinate)
        
        distance = mapPoint1.distance(to: mapPoint2) / 1000
    }
}
