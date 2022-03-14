//
//  CallAnalysisPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import Foundation

class CallAnalysisPresenter {
    weak var View: CallAnalysisVC!
    var callsInfo = [RecordedCallModel]()
    init(View: CallAnalysisVC) {
        self.View = View
    }
    
    func getCallAnalysis() {
        
    }
    
    func getCallsNumber() -> Int{
        return callsInfo.count
    }
    
    func configureRecordedCallModel()-> [RecordedCallModel]{
        return callsInfo
    }
}
