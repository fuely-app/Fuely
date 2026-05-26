//
//  StationCell.swift
//  Fuely
//
//  Created by Jarrod Norwell on 22/5/2026.
//

import ColourKit
import ConstraintKit
import FontKit
import MapKit
import OnboardingKit
import UIKit

class StationCell : UICollectionViewCell {
    var visualEffectView: UIVisualEffectView? = nil
    
    var label: UILabel? = nil,
        secondaryLabel: UILabel? = nil,
        tertiaryLabel: UILabel? = nil
    
    var mapView: MKMapView? = nil
    
    var callButton: UIButton? = nil
    
    var effect: UIGlassEffect = UIGlassEffect(style: .regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = backgroundColor
        
        visualEffectView = UIVisualEffectView(effect: effect)
        guard let visualEffectView else {
            return
        }
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.cornerConfiguration = UICornerConfiguration.uniformCorners(radius: UICornerRadius.fixed(32.0))
        insertSubview(visualEffectView, belowSubview: self)
        
        let configuration: UIButton.Configuration = .configuration(.medium, .capsule,
                                                                   UIImage(systemName: "phone.fill"), nil,
                                                                   .medium, .systemGreen)
        
        callButton = UIButton(configuration: configuration, primaryAction: UIAction { action in
            guard let url: URL = URL(string: "tel://\(self.phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
                return
            }
            
            UIApplication.shared.open(url)
        })
        guard let callButton else {
            return
        }
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.configurationUpdateHandler = { button in
            button.isEnabled = self.hasPhoneNumber
            guard var configuration: UIButton.Configuration = button.configuration else {
                return
            }
            
            configuration.baseForegroundColor = .white
            configuration.baseBackgroundColor = self.hasPhoneNumber ? .systemGreen : .systemGray
            
            button.configuration = configuration
        }
        addSubview(callButton)
        
        label = UILabel()
        guard let label else {
            return
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold(from: .title3)
        label.text = "Brand Name"
        label.textAlignment = .left
        label.textColor = .label
        addSubview(label)
        
        secondaryLabel = UILabel()
        guard let secondaryLabel else {
            return
        }
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = UIFont.bold(from: .title3)
        secondaryLabel.text = "Price"
        secondaryLabel.textAlignment = .left
        secondaryLabel.textColor = .tintColor
        addSubview(secondaryLabel)
        
        tertiaryLabel = UILabel()
        guard let tertiaryLabel else {
            return
        }
        tertiaryLabel.translatesAutoresizingMaskIntoConstraints = false
        tertiaryLabel.font = UIFont.regular(from: .callout)
        tertiaryLabel.text = "Address"
        tertiaryLabel.textAlignment = .left
        tertiaryLabel.textColor = .secondaryLabel
        addSubview(tertiaryLabel)
        
        mapView = MKMapView()
        guard let mapView else {
            return
        }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.cornerConfiguration = UICornerConfiguration.uniformCorners(radius: UICornerRadius.fixed(22.0))
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        addSubview(mapView)
        
        addConstraints([
            visualEffectView.top.constraint(equalTo: salg.top),
            visualEffectView.left.constraint(equalTo: salg.left),
            visualEffectView.bottom.constraint(equalTo: salg.bottom),
            visualEffectView.right.constraint(equalTo: salg.right),
            
            callButton.top.constraint(equalTo: salg.top, constant: 20.0),
            callButton.right.constraint(equalTo: salg.right, constant: -20.0),
            callButton.width.constraint(equalTo: callButton.salg.height, multiplier: 3.0 / 2.0),
            
            label.top.constraint(equalTo: salg.top, constant: 20.0),
            label.left.constraint(equalTo: salg.left, constant: 20.0),
            
            secondaryLabel.top.constraint(equalTo: salg.top, constant: 20.0),
            secondaryLabel.left.constraint(equalTo: label.salg.right, constant: 8.0),
            secondaryLabel.right.constraint(lessThanOrEqualTo: callButton.salg.left, constant: -20.0),
            
            tertiaryLabel.top.constraint(equalTo: label.salg.bottom, constant: 8.0),
            tertiaryLabel.left.constraint(equalTo: salg.left, constant: 20.0),
            tertiaryLabel.right.constraint(lessThanOrEqualTo: callButton.salg.left, constant: -20.0),
            
            mapView.top.constraint(equalTo: tertiaryLabel.salg.bottom, constant: 20.0),
            mapView.left.constraint(equalTo: salg.left, constant: 20.0),
            mapView.right.constraint(equalTo: salg.right, constant: -20.0),
            mapView.height.constraint(equalTo: mapView.salg.width, multiplier: 3.0 / 9.0),
            mapView.bottom.constraint(equalTo: salg.bottom, constant: -20.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hasPhoneNumber: Bool = true
    var phoneNumber: String = ""
    func set(station: API.Item) {
        guard let label, let secondaryLabel, let tertiaryLabel, let mapView else {
            return
        }
        
        phoneNumber = station.phone.trimmingCharacters(in: .whitespacesAndNewlines)
        hasPhoneNumber = !phoneNumber.isEmpty
        if let callButton {
            callButton.setNeedsUpdateConfiguration()
        }
        
        var tertiaryString: String = station.address.capitalized
        if hasPhoneNumber {
            tertiaryString.append(", \(phoneNumber.capitalized)")
        }
        
        label.text = station.brand.string
        secondaryLabel.text = String(format: "$%.2f", station.price / 100.0)
        tertiaryLabel.text = tertiaryString
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: station.latitude,
                                                                        longitude: station.longitude)
        
        let annotation: MKPointAnnotation = MKPointAnnotation(coordinate: coordinate)
        mapView.addAnnotation(annotation)
        
        mapView.region = MKCoordinateRegion(center: coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.003,
                                                                   longitudeDelta: 0.003))
    }
}

extension StationCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKMarkerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.glyphImage = UIImage(systemName: "fuelpump.fill")
        annotationView.markerTintColor = .tintColor
        return annotationView
    }
}

/*
class StationCell : UICollectionViewCell {
    var indexLabel: UILabel? = nil
    var textLabel: UILabel? = nil,
        secondaryTextLabel: UILabel? = nil,
        tertiaryLabel: UILabel? = nil
    
    var mapView: MKMapView? = nil
    var button: UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indexLabel = .init()
        guard let indexLabel else {
            return
        }
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.font = UIFont.regular(from: .headline)
        indexLabel.textColor = .secondaryLabel
        addSubview(indexLabel)
        
        textLabel = .init()
        guard let textLabel else {
            return
        }
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.regular(from: .headline)
        textLabel.textColor = .tintColor
        addSubview(textLabel)
        
        secondaryTextLabel = .init()
        guard let secondaryTextLabel else {
            return
        }
        secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextLabel.font = UIFont.regular(from: .title3)
        secondaryTextLabel.textColor = .label
        addSubview(secondaryTextLabel)
        
        mapView = .init()
        guard let mapView else {
            return
        }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        mapView.layer.cornerCurve = .continuous
        mapView.layer.cornerRadius = 15
        addSubview(mapView)
        
        tertiaryLabel = .init()
        guard let tertiaryLabel else {
            return
        }
        tertiaryLabel.translatesAutoresizingMaskIntoConstraints = false
        tertiaryLabel.font = UIFont.regular(from: .subheadline)
        tertiaryLabel.textColor = .tertiaryLabel
        addSubview(tertiaryLabel)
        
        var configuration: UIButton.Configuration = .glass()
        configuration.buttonSize = .small
        configuration.cornerStyle = .capsule
        configuration.image = .init(systemName: "ellipsis")
        
        button = .init(configuration: configuration)
        guard let button else {
            return
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        mapView.addSubview(button)
        
        addConstraints([
            indexLabel.topAnchor.constraint(equalTo: topAnchor),
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            indexLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            secondaryTextLabel.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 8),
            secondaryTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondaryTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: secondaryTextLabel.bottomAnchor, constant: 12),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 3 / 5),
            
            tertiaryLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 12),
            tertiaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tertiaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            tertiaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            button.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let mapView, let button, let configuration = button.configuration else {
            return
        }
        
        mapView.layer.cornerRadius = configuration.background.cornerRadius + 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexLabel = nil
        textLabel = nil
        secondaryTextLabel = nil
        mapView = nil
        tertiaryLabel = nil
        button = nil
    }
    
    func set(item: API.Item, index: Int) {
        guard let indexLabel, let textLabel, let secondaryTextLabel, let tertiaryLabel else {
            return
        }
        
        indexLabel.text = item.brand.string
        textLabel.text = .init(format: "$%.3f", item.price / 100)
        secondaryTextLabel.text = item.tradingName
        tertiaryLabel.text = "\(item.address) • \(item.phone)"
        
        guard let mapView else {
            return
        }
        
        let annotation: MKPointAnnotation = .init(coordinate: .init(latitude: item.latitude, longitude: item.longitude))
        mapView.addAnnotation(annotation)
        
        mapView.region = .init(center: .init(latitude: item.latitude, longitude: item.longitude),
                               span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003))
    }
}
*/
