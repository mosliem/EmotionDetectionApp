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
     var lastDate = Date()
    init(View:DashboardVC) {
        self.View = View
    }
    
    func getLineChartData()-> LineChartData{
        var entry = [ChartDataEntry]()
        
        for x in 1 ..< 8 {
            entry.append(ChartDataEntry(x: Double(x), y: Double(Int.random(in: 1...4))))
        }
        let set = LineChartDataSet(entries: entry , label: "")
        set.colors = [.red, .blue , .cyan]
        set.circleRadius = 4
        set.circleHoleColor = .blue
        set.lineWidth = 1.8
        let data = LineChartData(dataSet: set)
        return data
    }
    
    func getPieChartData() -> PieChartData{
        var entry = [PieChartDataEntry]()
        entry.append(PieChartDataEntry(value: 10, label: "Happy"))
        entry.append(PieChartDataEntry(value: 5, label: "Sad"))
        entry.append(PieChartDataEntry(value: 7, label: "Neutral"))
        entry.append(PieChartDataEntry(value: 4, label: "Angry"))
        
        
        let set = PieChartDataSet(entries: entry)
        set.colors = [.red , .link , .darkText , .orange]
        set.valueFont = UIFont(name: "CircularStd-Bold", size: 15)!
        set.entryLabelFont = UIFont(name: "CircularStd-Bold", size: 15)!
        let data = PieChartData(dataSet: set)
        return data
    }
    
    func getcurrentWeekDate() -> String{
        let currnetDate = DateFormatter.dateFormatter.string(from: Date())
        var dayComponent = DateComponents()
        dayComponent.day = 7
        let weekDate = DateFormatter.dateFormatter.string(from: Calendar.current.date(byAdding: dayComponent, to: Date())!)
        let newDate = "\(currnetDate) - \(weekDate)"
        return newDate
    }
    
    func increasingDatePressed() -> String{
        let currnetDate = DateFormatter.dateFormatter.string(from: lastDate)
        var dayComponent = DateComponents()
        dayComponent.day = 7
        lastDate = Calendar.current.date(byAdding: dayComponent, to: lastDate)!
        let weekDate = DateFormatter.dateFormatter.string(from: lastDate)
        let newDate = "\(currnetDate) - \(weekDate)"
        View.configureMoodGraphView()
        return newDate
    }
    
    func decreasingDatePressed() -> String {
        
        let endWeekDate = DateFormatter.dateFormatter.string(from: lastDate)
        var dayComponent = DateComponents()
        
        dayComponent.day = -7
        lastDate = Calendar.current.date(byAdding: dayComponent, to: lastDate)!
        let startWeekDate = DateFormatter.dateFormatter.string(from: lastDate)
        let newDate = "\(startWeekDate) - \(endWeekDate)"
        
        View.configureMoodGraphView()
        return newDate
    }
    
}

