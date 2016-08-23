//
//  SLLinkedInManager.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

let kLinkedInProfileDetailsUrl = LINKEDIN_API_URL + "/people/~:(email-address,id,first-name,last-name,picture-url)?format=json"

let kLinkedInProfileErrorMessage = "Failed to fetch LinkedIn profile details. Please try again"
let kLinkedInInvalidRequestErrorMessage = "There is something wrong with the request"
let kLinkedInUserCancelledErrorMessage = "User has cancelled the operation"
let kLinkedInUnknownErrorMessage = "Unable to complete request due to a unknown error"
let kLinkedInServerErrorMessage = "An error occurred within LinkedIn's system"
let kLinkedInAppNotFoundErrorMessage = "Linkedin App not found on device. You need to download the LinkedIn App in order to connect with LinkedIn"
let kLinkedInNotAuthenticatedErrorMessage = "Authentication failed. Please try again."

class SLLinkedInManager: NSObject {
    
    static let sharedInstance = SLLinkedInManager()
    var details: [(String, String?)] = []
    
    
    // MARK: LinkedIn Details
    
    func userDetails(success: (Bool) -> Void , failure: (String) -> Void) {
        LISDKAPIHelper.sharedInstance().getRequest(kLinkedInProfileDetailsUrl, success: { (response) in
            let data = response.data.dataUsingEncoding(NSUTF8StringEncoding)
            
            do {
                let dictResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                self.details = [("First Name", (dictResponse.objectForKey("firstName") as? String)!), ("Last Name", (dictResponse.objectForKey("lastName") as? String)!)]
                
                //Check and add email
                if let email = dictResponse.objectForKey("emailAddress") {
                    self.details.append(("Email", email as? String))
                }
                
                //Check and add headline
                if let email = dictResponse.objectForKey("headline") {
                    self.details.append(("Headline", email as? String))
                }
                
                //Check and add profile URL
                if let pictureUrl = dictResponse.objectForKey("pictureUrl") {
                    self.details.insert(("Picture", pictureUrl as? String), atIndex: 0)
                } else {
                    self.details.insert(("Picture", "Dummy Url"), atIndex: 0)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    success(true)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    failure(kLinkedInProfileErrorMessage)
                })
            }
        }) { (error) in
            dispatch_async(dispatch_get_main_queue(), {
                if (error != nil) {
                   failure(SLLinkedInManager.sharedInstance.errorMessageForErrorcode(error.code))
                } else {
                    failure(kLinkedInProfileErrorMessage)
                }
                
            })
        }
    }
    
    func errorMessageForErrorcode(code: Int) -> String {
        switch code {
            
        case 0: //.NONE
            return kCommonErrorMessage
        case 1: //.INVALID_REQUEST
            return kLinkedInInvalidRequestErrorMessage
        case 2: //.NETWORK_UNAVAILABLE
            return kCommonOfflineErrorMessage
        case 3: //.USER_CANCELLED
            return kLinkedInUserCancelledErrorMessage
        case 4: //.UNKNOWN_ERROR
            return kLinkedInUnknownErrorMessage
        case 5: //.SERVER_ERROR
            return kLinkedInServerErrorMessage
        case 6: //.LINKEDIN_APP_NOT_FOUND
            return kLinkedInAppNotFoundErrorMessage
        case 7: //.NOT_AUTHENTICATED
            return kLinkedInNotAuthenticatedErrorMessage
            
        default:
            return kCommonErrorMessage
        }
    }
    
    //LinkedIn Logout
    func logout() {
        self.details =  []
        LISDKAPIHelper.sharedInstance().cancelCalls()
        LISDKSessionManager.clearSession()
    }
    
}
