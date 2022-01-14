    //
//  MapViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var googleMap = GMSMapView()
    var markers: [GMSMarker] = []
    
    private var presenter: MapPresenterInput!
    
    func inject(presenter: MapPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let model = MapModel()
        let presenter = MapPresenter(view: self)
        inject(presenter: presenter)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "GourmandCell", bundle: nil), forCellWithReuseIdentifier: "GourmandCell")
        collectionView.register(UINib(nibName: "TravelCell", bundle: nil), forCellWithReuseIdentifier: "TravelCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
        
    }
    
    
}

extension MapViewController: UICollectionViewDelegate{
    
}

extension MapViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GourmandCell", for: indexPath) as! GourmandCell
        
        return cell
    }
    
}

extension MapViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
//        collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .right, animated: true)
        print(marker.title)
        
        marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
        googleMap.selectedMarker = marker //デフォルトで情報ウィンドウを表示
        
        return true
    }
    
}


extension MapViewController: MapPresenterOutput{
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.68154,longitude: 139.752498, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        self.googleMap = mapView
        self.view.addSubview(googleMap)
        self.view.sendSubviewToBack(googleMap)
        googleMap.delegate = self
        
        let lat = [35.68154,35.6954496]
        let log = [139.752498,139.7514154]
        let title = ["皇居","九段下駅"]

        for i in 0..<2{
            makeMarker(lat: lat[i], log: log[i], title: title[i])
        }
    }
    
    func makeMarker(lat: Double,log: Double,title: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat,log)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.title = "\(title)"
        marker.snippet = "Tokyo"
        marker.map = googleMap
    }
    
    func reloadMap() {
        setupMap()
    }
    
}

