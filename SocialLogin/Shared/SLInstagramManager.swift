//
//  SLInstagramManager.swift
//  SocialLogin
//
//  Created by Rajtharan Gopal on 03/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLInstagramManager: NSObject {

    static let sharedInstance = SLInstagramManager()
    var details: [(String, String?)] = []
    var accessToken: String?

    func userDetails(code: String, success: (Bool) -> Void , failure: (String) -> Void) {
        let params = ["client_id": kClientId,
                      "client_secret": kClientSecret,
                      "grant_type": kGrantType,
                      "redirect_uri": kRedirectUri,
                      "code": code]
        
        guard let url = NSURL(string: kInstagramAccessTokenPath) else {
            return
        }
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //This is mandatory for instagram API
        request.HTTPMethod = "POST"
        
        let stringParams = params.paramsString()
        let dataParams = stringParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let paramsLength = String(format: "%d", dataParams!.length)
        request.setValue(paramsLength, forHTTPHeaderField: "Content-Length")
        request.HTTPBody = dataParams
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            var json: AnyObject = [:]
            
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    failure(error.localizedDescription)
                    return
                })
            }
            guard let data = data else {
                return
            }
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            } catch {
                // Do nothing
            }
            print(json)
            if let error = json["error_message"] as? String {
                failure(error)
            }
            if let accessToken = json["access_token"] as? String {
                self.accessToken = accessToken
                print(accessToken)
            }
            if let user = json["user"] as? [String : String] {
                let name = user["full_name"]
                let profilePicture = user["profile_picture"]
                let userName = user["username"]
                let details: [(String, String?)] = [("Picture", profilePicture),("Full Name", name!), ("Username", "\(userName!)")]
                self.details = details
                dispatch_async(dispatch_get_main_queue(), {
                    success(true)
                })
            }
        }
        task.resume()
    }
    
    func logout() {
        self.details =  []
        kAppDelegate.instagramAccessToken = nil
        let cookieJar : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies! as [NSHTTPCookie]{
            if cookie.domain == "www.instagram.com" || cookie.domain == "api.instagram.com"{
                cookieJar.deleteCookie(cookie)
            }
        }
    }

}
