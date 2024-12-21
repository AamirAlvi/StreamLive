//
//  CommentTableViewCell.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    var comment: CommentData! {
        didSet {
            self.lblUserName.text = comment.username
            self.lblComment.text  = comment.comment
            let url = URL(string: comment.picURL)
            imgProfile.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = nil
        selectionStyle = .none
        imgProfile.layer.cornerRadius = imgProfile.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
