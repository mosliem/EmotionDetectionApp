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
        
        for x in 1 ..< 8 {
            entry.append(ChartDataEntry(x: Double(x), y: Double(Int.random(in: 1...4))))
            print(entry)
        }
        let set = LineChartDataSet(entries: entry , label: "")
        set.colors = [.red, .blue , .cyan]
        set.circleRadius = 4
        set.circleHoleColor = .blue
        set.lineWidth = 1.8
        let data = LineChartData(dataSet: set)
        return data
    }
    
}

