//
//  SelectGenreCell.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/11.
//

import UIKit


class SelectGenreCell: UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    private var view:GourmandSearchViewInput!
    private var dataSource:GourmandSearchInput!
    
    func inject(view:GourmandSearchViewInput,dataSource:GourmandSearchInput){
        self.view = view
        self.dataSource = dataSource
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setConfiguration(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        collectionView.register(UINib(nibName: "ChoosingGenreCell", bundle: nil), forCellWithReuseIdentifier: "choosingGenreCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @objc func deleteButton(_ sender:UIButton){
        let cell = sender.superview?.superview?.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        self.view.pushDeleteButton(at: indexPath!.row)
    }
}

extension SelectGenreCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.searchData.genre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "choosingGenreCell", for: indexPath) as! ChoosingGenreCell
        cell.label.text = self.dataSource!.searchData.genre[indexPath.row].name
        cell.deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)
        
        if indexPath.row == self.dataSource.searchData.genre.count - 1{
            self.collectionViewHeight.constant = self.collectionView.intrinsicContentSize.height
        }
        
        return cell
    }
}

extension SelectGenreCell:GourmandSearchViewOutput{
    
    func loadCollectionView() {
        self.setConfiguration()
        self.reloadData()
    }
    
    func reloadDeleteRows(at indexPaths: [IndexPath]) {
        self.collectionView.deleteItems(at: indexPaths)
        self.collectionView.performBatchUpdates({
            self.collectionView.layoutIfNeeded()
            self.collectionViewHeight.constant = self.collectionView.intrinsicContentSize.height
            self.view.requestTableViewLayoutRebuilding()
        }, completion: nil)
    }
    
    
    func reloadData() {
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
        self.collectionViewHeight.constant = self.collectionView.intrinsicContentSize.height
    }
}
