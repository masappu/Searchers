    //
//  MapViewController.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/10.
//

import UIKit
import GoogleMaps
import SDWebImage


class MapViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var googleMap = GMSMapView()
    var markers: [GMSMarker] = []
    var searchBar = UISearchBar()
    var pickerViewOfCategory = UIPickerView()
    var textFieldInsideSearchBar = UITextField()
    let categoryArray = ["300", "500", "1000", "2000", "3000"]
    var locationManager = CLLocationManager()
    let toolbarOfCategory = UIToolbar()
    var gourmandSearchData = GourmandSearchDataModel()

    
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
        
//        presenter.loadMap(idoValue: 35.828, keidoValue: 139.6903, rangeCount: 2, memberCount: 2)
        presenter.loadMap(gourmandSearchData: gourmandSearchData)
        presenter.configureSubViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldInsideSearchBar.endEditing(true)
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
    
    func setUpMap(idoValue:Double,keidoValue:Double) {
        googleMap.removeFromSuperview()
        searchBar.text = ""
        let camera = GMSCameraPosition.camera(withLatitude: idoValue,longitude: keidoValue, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        self.googleMap = mapView
        self.view.addSubview(googleMap)
        self.view.sendSubviewToBack(googleMap)
        googleMap.delegate = self
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        let shopDataArray = presenter.shopDataArray!
        for shopDataDic in shopDataArray{
            makeMarker(shopData: shopDataDic.value!)
        }
        collectionView.reloadData()
    }
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
   
    func setUpPickerView(){
        pickerViewOfCategory.delegate = self
        pickerViewOfCategory.dataSource = self

        //カテゴリーのピッカーの生成
        let buttonItemOfCategory = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(doneButtonOfCategory))
        toolbarOfCategory.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        toolbarOfCategory.setItems([buttonItemOfCategory], animated: true)
    }
    
    func setUpSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
//            let frame = CGRect(x: 0, y: 0, width: 100, height: 20)
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            self.searchBar = searchBar
            searchBar.delegate = self
            searchBar.placeholder = "500m以内を検索中"
            searchBar.tintColor = UIColor.darkGray
            searchBar.keyboardType = UIKeyboardType.default
            searchBar.showsSearchResultsButton = true
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            textFieldInsideSearchBar = (searchBar.value(forKey: "searchField") as? UITextField)!
            textFieldInsideSearchBar.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
            textFieldInsideSearchBar.backgroundColor = UIColor(red: 100, green: 100, blue: 0, alpha: 0.2)
            textFieldInsideSearchBar.layer.borderColor = UIColor.darkGray.cgColor
            textFieldInsideSearchBar.layer.borderWidth = 0.5
            textFieldInsideSearchBar.layer.cornerRadius = 7
            textFieldInsideSearchBar.inputView = pickerViewOfCategory
            textFieldInsideSearchBar.inputAccessoryView = toolbarOfCategory
            
        }
    }
    
    func makeMarker(shopData:ShopData) {
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
    }
    
    func setUpCollectionView() {
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

extension MapViewController: UIPickerViewDelegate,UIPickerViewDataSource{

    @objc func doneButtonOfCategory(){
        textFieldInsideSearchBar.endEditing(true)
        searchBar.placeholder = "\(searchBar.text!)mを検索中"
        let rangeCount = categoryArray.firstIndex(of: "\(searchBar.text!)")! + 1
        searchBar.text = searchBar.text! + "m"
//        presenter.reloadMap(idoValue: 35.8155543, keidoValue: 139.7043617, rangeCount: firstIndex, memberCount: 2)
        presenter.reloadMap(gourmandSearchData: gourmandSearchData, rangeCount: rangeCount)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        textFieldInsideSearchBar.text = categoryArray[row]
        return categoryArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textFieldInsideSearchBar.text = categoryArray[row]
    }

}

extension MapViewController: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //キャンセルボタンを表示
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //検索バーのキャンセルがタップされた時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //キャンセルボタンを非表示
        searchBar.showsCancelButton = false
        //キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    
    //検索バーでEnterが押された時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Labelに入力した値を設定
        self.searchBar.placeholder = "\(searchBar.text)mを検索中"
    }

}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 端末の位置情報サービスがオンの場合
        if CLLocationManager.locationServicesEnabled() {
        // アプリの現在の認証ステータス
        let status = manager.authorizationStatus

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // 位置情報取得を開始
            manager.startUpdatingLocation()
        case .notDetermined:
            // ユーザーに許可をリクエスト
            manager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .restricted:
            break

        default:
            break
        }
    // 端末の位置情報サービスがオフの場合
    }else {
//       Alert.okAlert(vc: self, title: "位置情報サービスを\nオンにして下さい", message: "「設定」アプリ ⇒「プライバシー」⇒「位置情報サービス」からオンにできます")
    }
 }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("daigolocations")
        print(locations)
//        let userLocation = locations.last
//
//        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,longitude: userLocation!.coordinate.latitude, zoom: 17.0)
//        self.googleMap.animate(to: camera)

        locationManager.stopUpdatingLocation()
    }
    
}

class scrollView: UIScrollView {
// 
//    override func touchesBegan(touches: Set, withEvent event: UIEvent) {
//        superview?.touchesBegan(touches, withEvent: event)
//    }
// 
}
