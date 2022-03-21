//
//  TabBarController.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        roundTabBar()
        
    }

    private func roundTabBar(){
        
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: self.tabBar.bounds.minY+5, width: self.tabBar.bounds.width - 60, height: self.tabBar.bounds.height+10), cornerRadius: (self.tabBar.frame.width/2)).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        tabBar.barTintColor = .white
        tabBar.clipsToBounds = true
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
    }

}
