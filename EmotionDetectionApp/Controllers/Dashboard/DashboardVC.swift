//
//  DashboardVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/12/22.
//

import UIKit
import Charts
class DashboardVC: UIViewController,ChartViewDelegate {

    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var currentMoodImageView: UIImageView!
    @IBOutlet weak var currentMoodLabel: UILabel!
    @IBOutlet weak var CurrentMoodView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    var chart = LineChartView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileImageView()
        configureCurrentMoodView()
        configureMoodGraph()

    }
    private func configureProfileImageView(){
        
        ProfileImageView.clipsToBounds = true
        ProfileImageView.layer.cornerRadius = 40
        
        profileView.layer.cornerRadius = 40
        profileView.layer.shadowColor = UIColor.darkGray.cgColor
        profileView.layer.shadowOffset = CGSize.zero
        profileView.layer.shadowRadius = 2
        profileView.layer.shadowOpacity = 1.0
    }
    private func configureCurrentMoodView(){
        CurrentMoodView.layer.cornerRadius = 10
        CurrentMoodView.layer.shadowColor = UIColor.darkGray.cgColor
        CurrentMoodView.layer.shadowOffset = CGSize.zero
        CurrentMoodView.layer.shadowRadius = 2
        CurrentMoodView.layer.shadowOpacity = 0.9
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chart = LineChartView(frame: CGRect(x: 0, y:CurrentMoodView.bottom + 50, width: view.width, height: 300))
        view.addSubview(chart)
        var entry = [ChartDataEntry]()
        
        for x in 1 ..< 10 {
            entry.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = LineChartDataSet(entries: entry)
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        chart.data = data
        
        
    }
    private func configureMoodGraph(){
     
    }
}
