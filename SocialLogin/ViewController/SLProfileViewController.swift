//
//  SLProfileViewController.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

let kProfileDetailCell = "DetailsCellIdentifier"
let kFacebookProfileImageCell = "FacebookImageCellIdentifier"
let kLinkedInProfileImageCell = "LinkedInImageCellIdentifier"
let kLogoutCell = "LogoutCellIdentifier"

let kEstimatedRowHeight: CGFloat = 60.0
let kProfileCellRowHeight: CGFloat = 150.0

class SLProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var notFoundLabel: UILabel!
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    var activityIndicator: UIActivityIndicatorView?
    var profileArray: [(String, String?)] = []
    var activityIndicatoryBarButton: UIBarButtonItem?
    
    
    // MARK: View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (tableView != nil) {
            tableView.tableFooterView = UIView()
            tableView.estimatedRowHeight = kEstimatedRowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        customiseActivityIndicator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileDetails()
    }
    
    
    // MARK: Action Methods
    
    @IBAction func logoutButtonPressed() {
        // Show Alert before logout.
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let actionButton = UIAlertAction(title: "Logout", style: .Destructive) { (action) in
            
            if ((FBSDKAccessToken.currentAccessToken()) != nil) {
                FBSDKLoginManager().logOut()
            } else if LISDKSessionManager.hasValidSession() {
                SLLinkedInManager.sharedInstance.logout()
            } else if kAppDelegate.instagramAccessToken != nil {
                 SLInstagramManager.sharedInstance.logout()
            }
            kAppDelegate.configureRootViewController()
        }
        alertController.addAction(actionButton)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed() {
        fetchProfileDetails()
    }
    
    
    // MARK: Custom Methods
    
    func fetchProfileDetails() {
        activityIndicator?.startAnimating()
        navigationItem.setRightBarButtonItem(activityIndicatoryBarButton, animated: true)
        
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            SLFacebookManager.sharedInstance.userDetails { (connection, result, error) in
                self.profileArray = SLFacebookManager.sharedInstance.details
                self.reloadProfileData()
            }
        } else if LISDKSessionManager.hasValidSession() {
            
            SLLinkedInManager.sharedInstance.userDetails({ (status) in
                self.profileArray = SLLinkedInManager.sharedInstance.details
                self.reloadProfileData()
                }, failure: { (errorMessage) in
                    self.reloadProfileData()
                    SLAlertHelper.showAlertWith(kAlertTitleError, message: errorMessage, inController: self)
            })
        } else if kAppDelegate.instagramAccessToken != nil {
            SLInstagramManager.sharedInstance.userDetails(kAppDelegate.instagramAccessToken!, success: { (status) in
                self.profileArray = SLInstagramManager.sharedInstance.details
                self.reloadProfileData()
                }, failure: { (error) in
                    self.reloadProfileData()
                    SLAlertHelper.showAlertWith(kAlertTitleError, message: error, inController: self)
            })
        }
    }
    
    func reloadProfileData() {
        activityIndicator?.stopAnimating()
        navigationItem.setRightBarButtonItem(refreshButton, animated: true)
        if self.profileArray.count > 0 {
            notFoundLabel.hidden = true
            tableView.hidden = false
        } else {
            notFoundLabel.hidden = false
            tableView.hidden = true
        }
        tableView.reloadData()
    }
    
    func customiseActivityIndicator() {
        // Initialize activity indicator
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.stopAnimating()
        activityIndicatoryBarButton = UIBarButtonItem(customView: self.activityIndicator!)
    }
    
    
    // MARK: TableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Check to show the image for FB and LinkedIn
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                guard let imageCell = tableView.dequeueReusableCellWithIdentifier(kFacebookProfileImageCell, forIndexPath: indexPath) as? SLProfileImageCell else {
                    return UITableViewCell()
                }
               return imageCell
            } else if LISDKSessionManager.hasValidSession() {
                guard let imageCell = tableView.dequeueReusableCellWithIdentifier(kLinkedInProfileImageCell, forIndexPath: indexPath) as? SLProfileImageCell else {
                    return UITableViewCell()
                }
                imageCell.downLoadImage(self.profileArray[indexPath.row].1!)
                return imageCell
            } else if kAppDelegate.instagramAccessToken != nil {
                guard let imageCell = tableView.dequeueReusableCellWithIdentifier(kLinkedInProfileImageCell, forIndexPath: indexPath) as? SLProfileImageCell else {
                    return UITableViewCell()
                }
                imageCell.downLoadImage(self.profileArray[indexPath.row].1!)
            }
            return UITableViewCell()
        } else {
            guard let detailsCell = tableView.dequeueReusableCellWithIdentifier(kProfileDetailCell, forIndexPath: indexPath) as? SLProfileDetailsTableViewCell else {
                return UITableViewCell()
            }
            
            let profile = self.profileArray
            detailsCell.titleLabel?.text = profile[indexPath.row].0
            detailsCell.valueLabel?.text = profile[indexPath.row].1
            
            return detailsCell
        }
    }
    
    
    // MARK: TableView Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return kProfileCellRowHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }

}
