//
//  String+Trimming.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 3/21/22.
//

import Foundation

extension String {
    var trimmed: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
