//
//  ShowAlertsManager.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/21/22.
//

import Foundation
import UIKit

extension UIViewController {
    class func showAlertWithCancel(alertTitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
