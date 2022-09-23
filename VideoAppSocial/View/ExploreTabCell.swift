//
//  ExploreTabCell.swift

//
//  Created by Rabiya on 4/6/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import UIKit

class ExploreTabCell: UITableViewCell {

    @IBOutlet weak var createStoreView: UIView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var networkingView: UIView!
    @IBOutlet weak var createStoreBtn: UIButton!
    
    var createStoreBtnTapped : (()->())?
    var shopBtnTapped : (()->())?
    var networkingBtnTapped : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupView()
        // Initialization code
    }
    func setupView(){
        createStoreView.layer.shadowColor = UIColor.gray.cgColor
        createStoreView.layer.shadowOffset = CGSize(width: 0, height: 0)
        createStoreView.layer.shadowRadius = 3
        createStoreView.layer.shadowOpacity = 0.4
        createStoreView.layer.cornerRadius = 7.0
        
       shopView.layer.shadowColor = UIColor.gray.cgColor
       shopView.layer.shadowOffset = CGSize(width: 0, height: 0)
       shopView.layer.shadowRadius = 3
       shopView.layer.shadowOpacity = 0.4
        shopView.layer.cornerRadius = 7.0

        
        networkingView.layer.shadowColor = UIColor.gray.cgColor
        networkingView.layer.shadowOffset = CGSize(width: 0, height: 0)
        networkingView.layer.shadowRadius = 3
        networkingView.layer.shadowOpacity = 0.4
        networkingView.layer.cornerRadius = 7.0

        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func createStoreBtnClicked(_ sender: Any) {
        createStoreBtnTapped?()
    }
    
    
    @IBAction func shopBtnClicked(_ sender: Any) {
        shopBtnTapped?()
    }
    
    @IBAction func networkingBtnClicked(_ sender: Any) {
        networkingBtnTapped?()
        
    }
    
    
}
