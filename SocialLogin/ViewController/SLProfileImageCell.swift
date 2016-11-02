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
    @IBOutlet weak var googleProfileImageView: UIImageView!
    
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
    
    func googleProfileImage(urlString: String) {
            let url = NSURL(string: urlString as String)
            let request: NSURLRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if error == nil {
                self.googleProfileImageView.image = UIImage(data: data!)
            }
        }
    }
    
}
