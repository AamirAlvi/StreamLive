//
//  StreamHeaderView.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//

import Foundation
import UIKit
import Kingfisher

class StreamHeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblVideoUserName: UILabel!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblViewerCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet var cornerViews: [UIView]!
    @IBOutlet weak var exploreView: UIView!
    @IBOutlet weak var btnFollow: UIView!
    @IBOutlet weak var lblRoseCount: UILabel!
    
    let five = NSAttributedString(string: "/5", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    
    var videoData: VideoData! {
        didSet {
            lblVideoUserName.text = videoData.username
            lblTopic.text = videoData.topic
            lblViewerCount.text = "\(videoData.viewers)"
            lblLikeCount.text = "\(videoData.likes)"
            let url = URL(string: videoData.profilePicURL)
            imgProfile.kf.setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StreamHeaderView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let one = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 255/255.0, green: 183/255.0, blue: 99/255.0, alpha: 1.0)])
        let mutable = NSMutableAttributedString(attributedString: one)
        mutable.append(five)
        lblRoseCount.attributedText = mutable

        
    }
    
    override func awakeFromNib() {
        cornerViews.forEach({
            $0.layer.cornerRadius = 6.0
        })
        btnFollow.layer.cornerRadius = 8.0
        imgProfile.layer.cornerRadius = 8.0
        exploreView.layer.cornerRadius = 6.0
        exploreView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func addLike() {
        lblLikeCount.text = "\(videoData.likes + 1)"
    }
    
    func addRose() {
        let two = NSAttributedString(string: "2", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 255/255.0, green: 183/255.0, blue: 99/255.0, alpha: 1.0)])
        let mutable = NSMutableAttributedString(attributedString: two)
        mutable.append(five)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.lblRoseCount.attributedText = mutable
        }
    }
}

extension StreamHeaderView: RoseActionDelegate {    
    
    func roseTapped(for videoData: VideoData) {
        addRose()
    }
}
