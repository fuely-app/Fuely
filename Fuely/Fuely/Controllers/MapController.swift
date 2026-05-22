//
//  MapController.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import ColourKit
import ConstraintKit
import FontKit
import MapKit
import OnboardingKit
import SwiftUI
import UIKit

class MapController : UIViewController {
    var mapView: MKMapView? = nil
    var hostingController: UIHostingController<MeshGradientView>? = nil
    var visualEffectView: UIVisualEffectView? = nil
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        mapView = MKMapView()
        guard let mapView else {
            return
        }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        view.addSubview(mapView)
        
        mapView.top.constraint(equalTo: view.top).isActive = true
        mapView.left.constraint(equalTo: view.left).isActive = true
        mapView.bottom.constraint(equalTo: view.bottom).isActive = true
        mapView.right.constraint(equalTo: view.right).isActive = true
        
        hostingController = UIHostingController(rootView: MeshGradientView(colours: Colour.vibrantBlues))
        guard let hostingController else {
            return
        }
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.top.constraint(equalTo: view.top).isActive = true
        hostingController.view.left.constraint(equalTo: view.left).isActive = true
        hostingController.view.bottom.constraint(equalTo: view.bottom).isActive = true
        hostingController.view.right.constraint(equalTo: view.right).isActive = true
        
        func openInMaps(with mode: String) {
            if let tabBarController: TabController = tabBarController as? TabController {
                if let station: API.Item = tabBarController.selectedStation {
                    let item: MKMapItem = MKMapItem(location: CLLocation(latitude: station.latitude,
                                                                         longitude: station.longitude),
                                                    address: nil)
                    item.name = station.brand.string
                    let result: Bool = item.openInMaps(launchOptions: [
                        MKLaunchOptionsDirectionsModeKey : mode
                    ])
                    
                    UINotificationFeedbackGenerator().notificationOccurred(result ? .success : .error)
                }
            }
        }
        
        func openInGoogleMaps() {
            if let tabBarController: TabController = tabBarController as? TabController {
                if let station: API.Item = tabBarController.selectedStation {
                    guard let url: URL = URL(string: "comgooglemaps://?q=\(station.latitude),\(station.longitude)"),
                          UIApplication.shared.canOpenURL(url) else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        return
                    }
                    
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    UIApplication.shared.open(url)
                }
            }
        }
        
        func openInWaze() {
            if let tabBarController: TabController = tabBarController as? TabController {
                if let station: API.Item = tabBarController.selectedStation {
                    guard let url: URL = URL(string: "waze://?ll=\(station.latitude),\(station.longitude)"),
                          UIApplication.shared.canOpenURL(url) else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        return
                    }
                    
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    UIApplication.shared.open(url)
                }
            }
        }
        
        func canOpenMapsApp(with scheme: String) -> Bool {
            return if let url: URL = URL(string: scheme) {
                UIApplication.shared.canOpenURL(url)
            } else {
                false
            }
        }
        
        var configuration: UIButton.Configuration = UIButton.Configuration.glass()
        configuration.buttonSize = .medium
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "arrow.up.forward.app")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 8.0
        configuration.title = "Open in Maps"
        
        let button: UIButton = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = UIMenu(children: [
            UIMenu(title: "More Options", preferredElementSize: .small, children: [
                UIAction(title: "Google", attributes: canOpenMapsApp(with: "comgooglemaps://") ? [] : .disabled) { action in
                    openInGoogleMaps()
                },
                UIAction(title: "Waze", attributes: canOpenMapsApp(with: "waze://") ? [] : .disabled) { action in
                    openInWaze()
                }
            ]),
            UIMenu(options: .displayInline, preferredElementSize: .medium, children: [
                UIAction(title: "Driving", image: UIImage(systemName: "car.fill")) { action in
                    openInMaps(with: MKLaunchOptionsDirectionsModeDriving)
                },
                UIAction(title: "Transit", image: UIImage(systemName: "bus.fill")) { action in
                    openInMaps(with: MKLaunchOptionsDirectionsModeTransit)
                },
                UIAction(title: "Walking", image: UIImage(systemName: "figure.walk")) { action in
                    openInMaps(with: MKLaunchOptionsDirectionsModeWalking)
                }
            ])
        ])
        button.showsMenuAsPrimaryAction = true
        view.addSubview(button)
        
        button.bottom.constraint(equalTo: view.salg.bottom, constant: -20.0).isActive = true
        button.centerX.constraint(equalTo: view.salg.centerX).isActive = true
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        guard let visualEffectView else {
            return
        }
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
        
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular(from: .headline)
        label.numberOfLines = 2
        label.text = "No Station Selected"
        label.textAlignment = .center
        label.textColor = .white
        vibrancyVisualEffectView.contentView.addSubview(label)
        
        label.centerX.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.centerX).isActive = true
        label.top.constraint(equalTo: vibrancyVisualEffectView.contentView.salg.top, constant: 20).isActive = true
        label.left.constraint(greaterThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.left, constant: 20).isActive = true
        label.right.constraint(lessThanOrEqualTo: vibrancyVisualEffectView.contentView.salg.right, constant: -20).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mapView: MKMapView, let hostingController, let visualEffectView else {
            return
        }
        
        if let tabBarController: TabController = tabBarController as? TabController {
            if let station: API.Item = tabBarController.selectedStation {
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
                
                let annotation: MKPointAnnotation = MKPointAnnotation(coordinate: coordinate)
                annotation.title = station.tradingName.capitalized
                annotation.subtitle = station.address.capitalized
                mapView.addAnnotation(annotation)
                
                mapView.region = MKCoordinateRegion(center: coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.003,
                                                                           longitudeDelta: 0.003))
                
                hostingController.view.isHidden = true
                visualEffectView.isHidden = true
            } else {
                hostingController.view.isHidden = false
                visualEffectView.isHidden = false
            }
        }
    }
}

extension MapController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let view: MKAnnotationView = views.first,
              let annotation: MKPointAnnotation = view.annotation as? MKPointAnnotation else {
            return
        }
        
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKMarkerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.markerTintColor = .tintColor
        return annotationView
    }
}
