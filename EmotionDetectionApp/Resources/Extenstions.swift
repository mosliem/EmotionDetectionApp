//
//  Extenstions.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import UIKit

extension UIImageView {
    func applyshadow(shadowRadius : CGFloat , shadowOpacity :Float , shadowColor : UIColor){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect:self.bounds).cgPath
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
}
extension UIView
{
    var height : CGFloat {
        return frame.size.height
    }
    var width : CGFloat  {
        return frame.size.width
    }
    var left : CGFloat {
        return frame.origin.x
    }
    var right : CGFloat {
        return left + width
    }
    var top : CGFloat {
        return frame.origin.y
    }
    var bottom : CGFloat{
        return top + height
    }
}
