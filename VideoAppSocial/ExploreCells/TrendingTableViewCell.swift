//
//  TrendingTableViewCell.swift

//
//  Created by Rabia Momin on 07/04/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TrendingTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    
    @IBOutlet weak var shareICon: UIImageView!
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var feedImg: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var likeCount: UIButton!
    
    @IBOutlet weak var visitStoreBtn: UIButton!
    var isSelecteD : Bool = false
    @IBOutlet weak var DescriptionLbl: UILabel!
    var likeBtnTapped : (()->())?
    var CommentBtnTapped : (()->())?
    var shareBtnTapped : (()->())?
    var likecount :Int = 0
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.cornerRadius = 18.0
        
        visitStoreBtn.layer.borderColor = UIColor.systemPink.cgColor
        visitStoreBtn.layer.borderWidth = 0.5
        visitStoreBtn.layer.cornerRadius = 4.0
        
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        
        feedImg.layer.addSublayer(videoLayer)
        selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe))
        shareICon.addGestureRecognizer(tap)
        shareICon.isUserInteractionEnabled = true
        // Initialization code
    }
    @objc func tappedMe()
    {
        shareBtnTapped?()
        print("Tapped on Image")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureVideo(videoUrl: String?, imageUrl: String?) {
        self.videoURL = videoUrl
//        feedImg.loadWithURL(url: imageUrl ?? "")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: height)
        
    }
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(feedImg.frame, from: feedImg)
        guard let videoFrame = videoFrameInParentSuperView,
              let superViewFrame = superview?.frame else {
                  return 0
              }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        likeBtn.isSelected = !likeBtn.isSelected

        if  isSelecteD == false {
            likecount =  likecount + 1
            let likeStr = "\(likecount)"
            likeCount.setTitle(likeStr, for: .normal)
            self.likeBtn.setImage(UIImage(named: "liked"), for: .normal)
            isSelecteD = true

        }else{
            self.likeBtn.setImage(UIImage(named: "like"), for: .normal)
             likecount = likecount - 1
            let likeStr = "\(likecount)"
            likeCount.setTitle(likeStr, for: .normal)
            isSelecteD = false

            
        }

        likeBtnTapped?()
    }
    
    
    @IBAction func CommentBtnClicked(_ sender: Any) {
    
        CommentBtnTapped?()
    }
    
}
extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}
