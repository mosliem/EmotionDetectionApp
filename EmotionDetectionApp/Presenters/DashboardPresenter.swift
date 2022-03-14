//
//  DashboardPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import Foundation
import Charts
class DashboardPresenter{
    weak var View :DashboardVC!
    init(View:DashboardVC) {
        self.View = View
    }
    
    func getChartData()-> LineChartData{
        var entry = [ChartDataEntry]()
        for x in 1 ..< 10 {
            entry.append(ChartDataEntry(x: Double(x), y: Double(Int.random(in: 1...12))))
        }
        let set = LineChartDataSet(entries: entry)
        set.colors = ChartColorTemplates.colorful()
        let data = LineChartData(dataSet: set)
        return data
    }
    
}
