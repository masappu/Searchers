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
    var latitude:Double?
    var longitude:Double?
    var searchRange:Int
    
    private let locaitonManager = LocationManager()
    
    init(){
        self.name = "未選択"
        self.latitude = Double()
        self.longitude = Double()
        self.searchRange = 1000
        
        self.locaitonManager.requestAuthorization()
        self.locaitonManager.LocationUpData()
        self.longitude = self.locaitonManager.longitude
        self.latitude = self.locaitonManager.latitude
        print("緯度：\(self.longitude)経度：\(self.latitude)")
    }
    
}

class LocationManager:NSObject,CLLocationManagerDelegate{
    
    private var locationManager:CLLocationManager!
    private(set) var latitude:Double?
    private(set) var longitude:Double?
    
    
    override init(){
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.latitude = nil
        self.longitude = nil
    }
    
    func requestAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func LocationUpData(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest // 測位精度（最高に設定）
            locationManager!.distanceFilter = 10 // 位置情報取得間隔
            locationManager!.activityType = .fitness // ユーザーアクティビティ（フィットネス）の設定
            locationManager!.requestLocation() // 位置情報の取得開始
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            print("緯度経度の取得に成功しました")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("まさし：\(error.localizedDescription)")
    }
    
}
