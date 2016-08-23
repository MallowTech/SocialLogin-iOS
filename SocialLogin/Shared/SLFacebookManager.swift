//
//  SLFacebookManager.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLFacebookManager: NSObject {

    static let sharedInstance = SLFacebookManager()
    var details: [(String, String?)] = []
    
    
    // MARK: Facebook Details
    
    func userDetails(handlers: FBSDKGraphRequestHandler) {
        let profileRequest = FBSDKGraphRequest(graphPath: "/me", parameters:  ["fields": "id, name, first_name, last_name, email, gender"], HTTPMethod: "GET")
        profileRequest.startWithCompletionHandler { (connection, result, error) in
            if (result != nil) {
                self.details = [("First Name", (result.objectForKey("first_name") as? String)!), ("Last Name", (result.objectForKey("last_name") as? String)!), ("Gender", (result.objectForKey("gender") as? String)!)]
                if let email = result.objectForKey("email") {
                    self.details.append(("Email", email as? String))
                }
                self.details.insert(("Picture", "Dummy Url"), atIndex: 0)
            }
            handlers(connection, result, error)
        }
      
        let profile = FBSDKProfile.currentProfile()
        if (profile != nil && details.count == 0) {
            details = [("Picture", "Dummy Url"), ("First Name", profile.firstName), ("Last Name", profile.lastName)]
        }
    }
    
    func logout() {
        self.details =  []
        FBSDKLoginManager().logOut()
    }

}
