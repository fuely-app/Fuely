//
//  Double.swift
//  Fuely
//
//  Created by Jarrod Norwell on 22/5/2026.
//

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

extension Double {
    var degrees: Double {
        self * 180 / .pi
    }
    
    var radians: Double {
        self * .pi / 180
    }
}
