//
//  SLInstagramLoginViewController.swift
//  SocialLogin
//
//  Created by Rajtharan Gopal on 03/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLInstagramLoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.color = UIColor.slInstagramThemeColor()
        activityIndicator?.startAnimating()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: kInstagramAuthenticatePath + "?client_id=" + kClientId + "&redirect_uri=" + kRedirectUri + "&response_type=code")!))
    }
    
    
    // MARK:- Web view delegate methods
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        activityIndicator?.startAnimating()
        var urlString: String = request.URL!.absoluteString!
        print("URL STRING : \(urlString) ")
        var UrlParts: [AnyObject] = urlString.componentsSeparatedByString("https://callback.com/?code=")
        print(UrlParts)
        if UrlParts.count > 1 {
            urlString = UrlParts[1] as! String
            let accessToken = urlString
            print("AccessToken = \(accessToken) ")
            kAppDelegate.instagramAccessToken = accessToken
            activityIndicator?.stopAnimating()
            kAppDelegate.configureUIAppearanceForInstagram()
            kAppDelegate.profileAsRootViewController()
            return false
        } else {
            activityIndicator?.stopAnimating()
        }
        return true
    }
    
}
