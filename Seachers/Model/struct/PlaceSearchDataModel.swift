//
//  PlaceSearchDataModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/12.
//

import Foundation
import CoreLocation

struct PlaceSearchDataModel{
    var name:String
    var latitude:Double
    var longitude:Double
    var searchRange:Int
    
    init(){
        self.name = "未選択"
        self.latitude = Double()
        self.longitude = Double()
        self.searchRange = 1000
    }
    
}

class LocationManager:NSObject,CLLocationManagerDelegate{

    private var locationManager:CLLocationManager!
    private(set) var latitude = Double()
    private(set) var longitude = Double()

    
    override init(){
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    func requestAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(){
        self.locationManager.distanceFilter = 10
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
    
    
}
