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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var googleMap = GMSMapView()
    var searchBar = UISearchBar()
    var pickerViewOfCategory = UIPickerView()
    var textFieldInsideSearchBar = UITextField()
    var locationManager = CLLocationManager()
    let toolbarOfCategory = UIToolbar()
    var gourmandSearchData = GourmandSearchDataModel()
    var previousVCString = String()

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
        
        presenter.loadMap(gourmandSearchData: gourmandSearchData)
        presenter.configureSubViews()
        presenter.previousVCString = previousVCString
    }

    @objc func doneButtonOfCategory(){
        presenter.requestDoneButtonOfCategory(text: searchBar.text!)
        textFieldInsideSearchBar.endEditing(true)
    }
    
    @objc func addToFavoritesButton(_ sender: UIButton){
        let cell = sender.superview?.superview?.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        presenter.addToFavoritesButton(indexPath: indexPath!)
    }
    
    @objc func goToWebVCButton(_ sender: UIButton){
        let cell = sender.superview?.superview?.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        presenter.goToWebVCButton(indexPath: indexPath!)
    }
    
}

extension MapViewController: UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter.requestScrollViewDidEndDecelerating(x: scrollView.contentOffset.x, width: view.frame.width)
    }
    
}

extension MapViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellType = MapCellType(rawValue: "\(previousVCString)")
        switch (cellType)! {
        case .gourmandCell:
            return presenter.shopDataArray!.count
        case .travelCell:
            return 1 //（仮）
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = MapCellType(rawValue: "\(previousVCString)")
        switch (cellType)! {
        case .gourmandCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellType!.cellIdentifier)", for: indexPath) as! GourmandCell
            let shopDataArray = presenter.shopDataArray!

            cell.shopImageView?.sd_setImage(with: URL(string: shopDataArray[indexPath.row].shopData.shop_image!), completed: nil)
            cell.area_genreLabel?.text = shopDataArray[indexPath.row].shopData.smallAreaName! + "/" + shopDataArray[indexPath.row].shopData.genreName!
            cell.shopNameLabel?.text = shopDataArray[indexPath.row].shopData.name
            cell.averageBudgetLabel?.text = shopDataArray[indexPath.row].shopData.budgetAverage
            cell.lunchLabel?.text = shopDataArray[indexPath.row].shopData.lunch
            cell.favButton!.addTarget(self, action: #selector(addToFavoritesButton(_:)), for: .touchUpInside)
            cell.favButton?.setImage(UIImage(systemName: shopDataArray[indexPath.row].favShop), for: .normal)
            cell.detailButton.addTarget(self, action: #selector(goToWebVCButton(_:)), for: .touchUpInside)

            return cell
        case .travelCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellType!.cellIdentifier)", for: indexPath) as! GourmandCell
            return cell
        }
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
        presenter.requestMapViewDidTap(marker: marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        searchBar.text = ""
        textFieldInsideSearchBar.endEditing(true)
    }
    
}

extension MapViewController: MapPresenterOutput{
    
    func indicatorViewStart() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func indicatorViewStop() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func goToWebVC(url: String) {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "webVC") as! WebViewController
        webVC.url = url
        self.present(webVC, animated: true, completion: nil)
    }
 
    func addToFavorites(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
  
    func responseMapViewDidTap(marker: GMSMarker, index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: true)
        marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
        googleMap.selectedMarker = marker //デフォルトで情報ウィンドウを表示
    }
    
    func responseScrollViewDidEndDecelerating(marker: GMSMarker) {
        marker.tracksInfoWindowChanges = true
        googleMap.selectedMarker = marker
    }
    
    func responseDoneButtonOfCategory(rangeCount: Int) {
        textFieldInsideSearchBar.endEditing(true)
        searchBar.placeholder = "\(searchBar.text!)mを検索中"
        searchBar.text = searchBar.text! + "m"
        presenter.reloadMap(gourmandSearchData: gourmandSearchData, rangeCount: rangeCount)
    }
    
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
        
        let markers = presenter.markers
        print("daigodaigo")
        print(markers.count)
        for marker in markers{
            marker.map = googleMap
        }
        collectionView.reloadData()
    }
   
    func setUpPickerView(){
        pickerViewOfCategory.delegate = self
        pickerViewOfCategory.dataSource = self

        let buttonItemOfCategory = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(doneButtonOfCategory))
        toolbarOfCategory.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        toolbarOfCategory.setItems([buttonItemOfCategory], animated: true)
    }
    
    func setUpSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            self.searchBar = searchBar
            searchBar.delegate = self
            searchBar.placeholder = "500m以内を検索中" //ここに渡ってきた検索範囲を入れる
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.categoryArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        textFieldInsideSearchBar.text = presenter.categoryArray[row]
        return presenter.categoryArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textFieldInsideSearchBar.text = presenter.categoryArray[row]
    }

}

extension MapViewController: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //検索バーのキャンセルがタップされた時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}

