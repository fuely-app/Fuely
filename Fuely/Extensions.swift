//
//  Extensions.swift
//  Fuely
//
//  Created by Jarrod Norwell on 28/9/2025.
//

import CoreLocation
import Foundation

extension Double {
    var normalizedDegrees: Double {
        var angle = truncatingRemainder(dividingBy: 360)
        if angle < 0 {
            angle += 360
        }
        return angle
    }
}

extension CLLocationCoordinate2D {
    func bearing(to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = latitude.radians
        let lon1 = longitude.radians
        
        let lat2 = destination.latitude.radians
        let lon2 = destination.longitude.radians
        
        let dLon = lon2 - lon1
        
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let y = sin(dLon) * cos(lat2)
        
        var degreesBearing = atan2(y, x).degrees
        if degreesBearing < 0 {
            degreesBearing += 360
        }
        return degreesBearing
    }
    
    func cardinal(from bearing: Double) -> String {
        switch bearing.normalizedDegrees {
        case 0..<22.5,
            337.5..<360: "North"
        case 22.5..<67.5: "North East"
        case 67.5..<112.5: "East"
        case 112.5..<157.5: "South East"
        case 157.5..<202.5: "South"
        case 202.5..<247.5: "South West"
        case 247.5..<292.5: "West"
        case 292.5..<337.5: "North West"
        default: "North"
        }
    }
}

private extension Double {
    var degrees: Double {
        self * 180 / .pi
    }
    
    var radians: Double {
        self * .pi / 180
    }
}
