//
//  SLGoogleManager.swift
//  SocialLogin
//
//  Created by Karthick Selvaraj on 02/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLGoogleManager: NSObject {
    static let sharedInstance = SLLinkedInManager()
    var details: [(String, String?)] = []
    var idToken: String = ""
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
}
