//
//  LocationAccess.swift
//  Fuely
//
//  Created by Jarrod Norwell on 21/5/2026.
//

import CoreLocation

@MainActor class LocationAccess : NSObject {
    var authorised: Bool = false
    var status: CLAuthorizationStatus = .notDetermined
    
    var manager: CLLocationManager = CLLocationManager()
    
    func checkAuthorisationStatus() {
        status = manager.authorizationStatus
        authorised = status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    func authorise() {
        manager.requestAlwaysAuthorization()
        authorised = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
    }
}
