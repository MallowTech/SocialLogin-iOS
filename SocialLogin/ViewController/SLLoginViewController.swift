//
//  SLLoginViewController.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

enum SLFacebookPermission: String {
    case PublicProfile = "public_profile"
    case Email = "email"
    
    static let allValues = [PublicProfile, Email]
}

class SLLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet var linkedInLoginButton: UIButton!

    
    // MARK: View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook Permissions
        facebookLoginButton.readPermissions = [SLFacebookPermission.PublicProfile.rawValue, SLFacebookPermission.Email.rawValue];
        
        // Background view with blur effect
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.frame = view.bounds
        imageView.contentMode = .ScaleToFill
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imageView.bounds
        blurredEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurredEffectView)
        
        view.sendSubviewToBack(blurredEffectView)
        view.sendSubviewToBack(imageView)
    }
    

    // MARK: LinkedIn Action Methods
    
    @IBAction func linkedInLoginButtonPressed() {
        LISDKSessionManager.createSessionWithAuth([LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) in
            if (LISDKSessionManager.hasValidSession()) {
                // Assign Theme Color
                kAppDelegate.configureUIAppearanceForLinkedIn()
                kAppDelegate.profileAsRootViewController()
            } else {
                SLAlertHelper.showAlertWith(kAlertTitleOops, message: kCommonErrorMessage, inController: self)
            }
            
        }) { (error) in
            var message = kCommonErrorMessage
            if (error != nil) {
               message = SLLinkedInManager.sharedInstance.errorMessageForErrorcode(error.code)
            }
            SLAlertHelper.showAlertWith(nil, message: message, inController: self)
        }
    }
    
    
    // MARK: FBSDKLoginButton Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (result.isCancelled) {// If user cancelled the facebook login
            SLAlertHelper.showAlertWith(nil, message: kFacebookUserCancelledErrorMessage, inController: self)
        } else if ((FBSDKAccessToken.currentAccessToken()) != nil) {// If user successfully loggedin to the Facebook
            // Assign Theme Color
            kAppDelegate.configureUIAppearanceForFaceBook()
            kAppDelegate.profileAsRootViewController()
        } else {// Any error occurs
            var message = kCommonErrorMessage
            if (error != nil) {
                message = error.localizedDescription
            }
            SLAlertHelper.showAlertWith(kAlertTitleError, message: message, inController: self)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // Nothing to implement here
    }
    
}
