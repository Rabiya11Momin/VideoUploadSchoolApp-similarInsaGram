//
//  IDproofCollectionViewCell.swift
//  TIO_WALLET
//
//  Created by Rabiya Momin on 22/03/21.
//

import UIKit

class TopCategoriesCell: UICollectionViewCell {

    @IBOutlet weak var idNamelbl: UILabel!
    @IBOutlet weak var idImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        idImg.layer.cornerRadius =  idImg.frame.size.height/2
//        idImg.dropShadowGray()
        // Initialization code
    }
    
    
    
    func initWithObject(dict : [String : Any]){
        
      
     
    }

}
