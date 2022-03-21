//
//  imageCache.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/21/22.
//

import UIKit

class Cache: NSObject , NSDiscardableContent {

    public var image: UIImage!

    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {

    }

    func discardContentIfPossible() {

    }

    func isContentDiscarded() -> Bool {
        return false
    }
}
