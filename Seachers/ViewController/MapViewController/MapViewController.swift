    //
//  MapViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GoogleMaps
import SDWebImage


class MapViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var googleMap = GMSMapView()
    var markers: [GMSMarker] = []
    var searchBar = UISearchBar()
    
    private var presenter: MapPresenterInput!
    
    func inject(presenter: MapPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = MapPresenter(view: self)
        inject(presenter: presenter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
        setupSearchBar()
        
    }
    
    func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            let searchBar: UISearchBar = UISearchBar(frame: frame)
            searchBar.delegate = self
            searchBar.placeholder = "500m"
            searchBar.tintColor = UIColor.darkGray
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.navigationBar.backgroundColor = .clear
            searchBar.backgroundColor = .white
            self.searchBar = searchBar
        }
    }
    
    
}

extension MapViewController: UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = Double(scrollView.contentOffset.x)
        let indexCount = x / view.frame.width
        let marker = markers[Int(indexCount)]
        marker.tracksInfoWindowChanges = true
        googleMap.selectedMarker = marker
    }
}

extension MapViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.shopDataArray == nil{
            return 0
        }else{
            return presenter.shopDataArray!.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GourmandCell", for: indexPath) as! GourmandCell
        let shopImageView = cell.shopImageView
        let area_genreLabel = cell.area_genreLabel
        let shopNameLabel = cell.shopNameLabel
        let averageBudgetLabel = cell.averageBudgetLabel
        let lunchLabel = cell.lunchLabel
        let favButton = cell.favButton
        let detailButton = cell.detailButton
        
        let shopDataArray = presenter.shopDataArray!
        
        shopImageView?.sd_setImage(with: URL(string: shopDataArray[indexPath.row].value!.shop_image!), completed: nil)
        area_genreLabel?.text = shopDataArray[indexPath.row].value!.smallAreaName! + "/" + shopDataArray[indexPath.row].value!.genreName!
        shopNameLabel?.text = shopDataArray[indexPath.row].value!.name
        averageBudgetLabel?.text = shopDataArray[indexPath.row].value!.budgetAverage
        lunchLabel?.text = shopDataArray[indexPath.row].value!.lunch
        
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
        
        let index = presenter.shopDataArray?.firstIndex(where: { $0.key == marker.title })
        collectionView.scrollToItem(at: IndexPath(row: index!, section: 0), at: .right, animated: true)
        marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
        googleMap.selectedMarker = marker //デフォルトで情報ウィンドウを表示
        
        return true
    }
    
}


extension MapViewController: MapPresenterOutput{
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.6954496,longitude: 139.7514154, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        self.googleMap = mapView
        self.view.addSubview(googleMap)
        self.view.sendSubviewToBack(googleMap)
        googleMap.delegate = self

        let shopDataArray = presenter.shopDataArray!
        for shopDataDic in shopDataArray{
            makeMarker(shopData: shopDataDic.value!)
        }
        collectionView.reloadData()
    }
    
    func makeMarker(shopData:ShopData) -> [GMSMarker] {
        let latitude = shopData.latitude!
        let longitude = shopData.longitude!
        let title = shopData.name!
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude,longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.title = "\(title)"
        marker.snippet = shopData.smallAreaName! + "/" + shopData.genreName!
        marker.map = googleMap
        markers.append(marker)
        
        return markers
    }
    
    func reloadMap() {
        setupMap()
    }
    
    func reloadCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "GourmandCell", bundle: nil), forCellWithReuseIdentifier: "GourmandCell")
        collectionView.register(UINib(nibName: "TravelCell", bundle: nil), forCellWithReuseIdentifier: "TravelCell")
    }
    
}

