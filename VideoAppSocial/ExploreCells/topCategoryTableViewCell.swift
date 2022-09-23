//
//  topCategoryTableViewCell.swift
//
//  Created by Rabiya on 4/6/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import UIKit

class topCategoryTableViewCell: UITableViewCell {
   
    var filters = NSMutableArray()

    @IBOutlet weak var topCategoryCollectioview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        filters = ["Fruit", "veggies"]
        // Initialization code
        setupCollViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCollViewCell(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.topCategoryCollectioview.collectionViewLayout = flowLayout
        self.topCategoryCollectioview.showsHorizontalScrollIndicator = false
        topCategoryCollectioview.delegate = self
        topCategoryCollectioview.dataSource = self
        topCategoryCollectioview.register(UINib(nibName: "TopCategoriesCell", bundle: VideoApp_Bundle), forCellWithReuseIdentifier: "TopCategoriesCell")
    }
    
    
    
}

extension topCategoryTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return 5
    
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collCell = topCategoryCollectioview.dequeueReusableCell(withReuseIdentifier: "TopCategoriesCell", for: indexPath) as! TopCategoriesCell
    let labelName = ["Jones","Demil","pinkle","Lemis","Hope"]
    let options = labelName[indexPath.row]
    collCell.idNamelbl.text = options
    return collCell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:71, height: collectionView.frame.height)
    }
}

