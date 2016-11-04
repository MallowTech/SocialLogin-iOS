//
//  SLConstant.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import Foundation

let kAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

// StoryBoard Name
let kMainStoryBoard = "Main"

// ViewController Identifiers
let kSLLogInViewController = "SLLogInViewController"
let kSLProfileViewController = "SLProfileViewController"

let kCommonErrorMessage = "Something went wrong. Please try again"
let kCommonOfflineErrorMessage = "Your Internet connection appears to be offline"
let kFacebookUserCancelledErrorMessage = "User has cancelled the Facebook login"
let kAlertTitleOops = "Oops!!"
let kAlertTitleError = "Error!!"

//Instagram details
let kClientId = "fbd7122dde04448b8d631a216e51aa64"
let kClientSecret = "82dac4df17a64049a9c88e574df15fbe"
let kGrantType = "authorization_code"
let kRedirectUri = "https://callback.com/"
let kInstagramAccessTokenPath = "https://api.instagram.com/oauth/access_token"
let kInstagramAuthenticatePath = "https://api.instagram.com/oauth/authorize/"
