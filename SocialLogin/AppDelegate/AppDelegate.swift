//
//  AppDelegate.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var googleImageURL: NSURL?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginButton.classForCoder()
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        
        // Google sign in setup
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        
        // Set UI Apperance 
        configureUIApperance()
        
        // Based on the details of user token
        configureRootViewController()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if (LISDKCallbackHandler.shouldHandleUrl(url)) {
            return LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if #available(iOS 9.0, *) {
            return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        } else {
            return true
        }
        
    }
    
    // MARK: Custom Methods
    
    func configureRootViewController() {
        if ((FBSDKAccessToken.currentAccessToken()) != nil || LISDKSessionManager.hasValidSession() || GIDSignIn.sharedInstance().currentUser != nil) {
            profileAsRootViewController()
        } else {
            loginAsRootViewController()
        }
    }
    
    func loginAsRootViewController() {
        let mainStoryBoard = UIStoryboard(name: kMainStoryBoard, bundle: nil)
        let rootViewController = mainStoryBoard.instantiateInitialViewController()
        window?.rootViewController = rootViewController
    }
    
    func profileAsRootViewController() {
        let mainStoryBoard = UIStoryboard(name: kMainStoryBoard, bundle: nil)
        let rootViewController = mainStoryBoard.instantiateViewControllerWithIdentifier(kSLProfileViewController)
        let navController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navController
    }
    
    func configureUIApperance() {
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            configureUIAppearanceForFaceBook()
        } else if (LISDKSessionManager.hasValidSession()) {
            configureUIAppearanceForLinkedIn()
        } else if GIDSignIn.sharedInstance().currentUser != nil {
            configureUIAppearanceForGoogle()
        }
        
    }
    
    func configureUIAppearanceForFaceBook() {
        UINavigationBar.appearance().tintColor = UIColor.slFacebookThemeColor()
        UINavigationBar.appearance().barTintColor = UIColor.slFacebookThemeColor()
    }
    
    func configureUIAppearanceForLinkedIn() {
        UINavigationBar.appearance().tintColor = UIColor.slLinkedInThemeColor()
        UINavigationBar.appearance().barTintColor = UIColor.slLinkedInThemeColor()
    }
    
    func configureUIAppearanceForGoogle() {
        UINavigationBar.appearance().tintColor = UIColor.slGoogleThemeColor()
        UINavigationBar.appearance().barTintColor = UIColor.slGoogleThemeColor()
    }
    
    
    // MARK: - Google GIDSignInDelegate methods
    
     func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let fullName = user.profile.name
            let email = user.profile.email
            if user.profile.hasImage == true {
                googleImageURL = user.profile.imageURLWithDimension(300)
            }
            let details: [(String, String?)] = [("Picture", "\((googleImageURL?.absoluteString!)! as String)"),("Full Name", "\(fullName)"), ("email", "\(email)")]
            SLGoogleManager.sharedInstance.details = details
            configureUIAppearanceForGoogle()
            profileAsRootViewController()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
     func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
            // Nothing to implement here
    }
    
}

