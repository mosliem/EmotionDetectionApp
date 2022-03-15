//
//  extension.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit
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
extension DateFormatter{
    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()
    
    static let displayDateFormatter : DateFormatter = {
        let Formmater = DateFormatter()
        Formmater.dateStyle = .medium
        return Formmater
    }()
}
extension String {
    static func formattedDate(dateString : String ) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: dateString) else {
            return dateString
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
