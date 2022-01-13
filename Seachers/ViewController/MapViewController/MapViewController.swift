//
//  MapViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GoogleMaps

enum CellType {
    case goumand
    case travel
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var mapview2 = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "GoumandCell", bundle: nil), forCellWithReuseIdentifier: "GoumandCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMap()
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.68154,longitude: 139.752498, zoom: 13)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(35.68154,139.752498)
        marker.title = "The Imperial Palace"
        marker.snippet = "Tokyo"
        marker.map = mapView
        
//        let camera = GMSCameraPosition.camera(withLatitude: 35.68154,longitude: 139.752498, zoom: 13)
//        mapview2 = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapview2.isMyLocationEnabled = true
//        view.addSubview(mapview2)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoumandCell", for: indexPath) as! GoumandCell
        
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

