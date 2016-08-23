//
//  SLAlertHelper.swift
//  SocialLogin
//
//  Created by Arasuvel Theerthapathy on 22/08/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class SLAlertHelper: NSObject {
    
    class func showAlertWith(title : String?, message : String?, inController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        inController.presentViewController(alertController, animated: true, completion: nil)
    }

}
