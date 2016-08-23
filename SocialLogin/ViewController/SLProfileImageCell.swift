//
//  SLProfileImageCell.swift
//  SocialLogin
//
//  Created by Yogesh Murugesh on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLProfileImageCell: UITableViewCell {

    @IBOutlet var profileView: FBSDKProfilePictureView!
    @IBOutlet var linkedInImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func downLoadImage(urlString: String) {
        self.linkedInImageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "user_profile")) { (image, error, type, url) in
            if ((image) != nil) {
                self.linkedInImageView.image = image
            }
        }
    }
    
}
