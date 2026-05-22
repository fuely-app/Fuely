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

class CompassController : UIViewController {
    var distance: CLLocationDistance? = nil
    var manager: CLLocationManager = CLLocationManager()
    
    var station: API.Item? = nil
    
    var imageView: UIImageView? = nil
    var containerView: UIView? = nil
    var label: UILabel? = nil,
        secondaryLabel: UILabel? = nil,
        tertiaryLabel: UILabel? = nil
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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
        
        let vibrancyVisualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemMaterial)))
        vibrancyVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.contentView.addSubview(vibrancyVisualEffectView)
        
        vibrancyVisualEffectView.top.constraint(equalTo: visualEffectView.contentView.top).isActive = true
        vibrancyVisualEffectView.left.constraint(equalTo: visualEffectView.contentView.left).isActive = true
        vibrancyVisualEffectView.bottom.constraint(equalTo: visualEffectView.contentView.bottom).isActive = true
        vibrancyVisualEffectView.right.constraint(equalTo: visualEffectView.contentView.right).isActive = true
        
        imageView = UIImageView(image: UIImage(systemName: "arrow.up.circle"))
        guard let imageView else {
            return
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        vibrancyVisualEffectView.contentView.addSubview(imageView)
        
        imageView.centerX.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerX).isActive = true
        imageView.centerY.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerY).isActive = true
        imageView.width.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.width, multiplier: 4 / 5).isActive = true
        imageView.height.constraint(equalTo: imageView.salg.width).isActive = true
        
        containerView = UIView()
        guard let containerView else {
            return
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyVisualEffectView.contentView.addSubview(containerView)
        
        containerView.top.constraint(equalTo: imageView.salg.bottom, constant: 20).isActive = true
        containerView.left.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.left, constant: 20).isActive = true
        containerView.bottom.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.bottom, constant: -20).isActive = true
        containerView.right.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.right, constant: -20).isActive = true
        
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
        
        tertiaryLabel.centerX.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerX).isActive = true
        tertiaryLabel.top.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.top, constant: 20).isActive = true
        tertiaryLabel.left.constraint(greaterThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.left, constant: 20).isActive = true
        tertiaryLabel.right.constraint(lessThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.right, constant: -20).isActive = true
        
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
        
        label.centerX.constraint(equalTo: containerView.salg.centerX).isActive = true
        label.bottom.constraint(equalTo: containerView.salg.centerY, constant: -4).isActive = true
        label.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20).isActive = true
        label.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20).isActive = true
        
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
        
        secondaryLabel.centerX.constraint(equalTo: containerView.salg.centerX).isActive = true
        secondaryLabel.top.constraint(equalTo: containerView.salg.centerY, constant: 4).isActive = true
        secondaryLabel.left.constraint(greaterThanOrEqualTo: containerView.salg.left, constant: 20).isActive = true
        secondaryLabel.right.constraint(lessThanOrEqualTo: containerView.salg.right, constant: -20).isActive = true
        
        manager.delegate = self
        manager.headingFilter = 0
        manager.distanceFilter = 0
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
}

extension CompassController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard let station: API.Item else {
            return
        }
        
        guard let imageView: UIImageView, let label: UILabel, let location: CLLocation = manager.location else {
            return
        }
        
        let bearing: Double = location.coordinate.bearing(to: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude))
        let deviceHeading: CLLocationDirection = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        let relativeBearing: Double = (bearing - deviceHeading).normalizedDegrees
        
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
