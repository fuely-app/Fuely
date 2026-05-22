//
//  Cell.swift
//  Fuely
//
//  Created by Jarrod Norwell on 6/10/2025.
//

import FontKit
import MapKit
import OnboardingKit
import UIKit

class Cell : UICollectionViewCell {
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
