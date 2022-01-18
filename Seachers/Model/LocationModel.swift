//
//  LocationModel.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/18.
//

import Foundation
import CoreLocation

protocol LocaitonModelInput{
    
    //位置情報取得のタイミングを通知する。
    func requestAuthorization()
    
}

protocol LocaitonModelOutput{
    
    //位置情報取得完了を通知し、データを渡す。
    func completedRequestLocaiton(request:CLLocationCoordinate2D)
    
}



class LocationModel:NSObject,LocaitonModelInput{
    
    private var locationManager:CLLocationManager! {
        let locaitonInfo = CLLocationManager()
        locaitonInfo.delegate = self
        locaitonInfo.desiredAccuracy = kCLLocationAccuracyBest
        locaitonInfo.distanceFilter = 10
        locaitonInfo.activityType = .fitness
        return locaitonInfo
    }
    private var presenter:LocaitonModelOutput!
    
    override init() {
        super.init()
    }
    
    required public init(presenter:LocaitonModelOutput) {
        self.presenter = presenter
    }
    
    func requestAuthorization(){
        let status = self.locationManager.authorizationStatus
        switch status {
        case .notDetermined,.restricted,.denied:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways,.authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .authorized:
            break
        default:
            break
        }
    }
    

    
    func showAlert(){
        
    }
}

extension LocationModel:CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status{
        case .notDetermined,.denied,.restricted:
            self.showAlert()
        case .authorizedAlways,.authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .authorized:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            self.presenter.completedRequestLocaiton(request: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("まさし：\(error.localizedDescription)")
    }
}
