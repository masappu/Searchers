//
//  SelectGenreCell.swift
//  Seachers
//
//  Created by 山口誠士 on 2022/01/11.
//

import UIKit

class SelectGenreCell: UITableViewCell{
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var genres:[GenreModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.invalidateIntrinsicContentSize()
        collectionView.register(UINib(nibName: "ChoosingGenreCell", bundle: nil), forCellWithReuseIdentifier: "choosingGenreCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(data:[GenreModel]){
        self.genres = data
        collectionView.reloadData()
    }
    
    @objc func deleteButton(_ sender:UIButton){
        
    }
    
}

extension SelectGenreCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "choosingGenreCell", for: indexPath) as! ChoosingGenreCell
        
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = self.genres[indexPath.row].name
        
        return cell
    }
    
}
