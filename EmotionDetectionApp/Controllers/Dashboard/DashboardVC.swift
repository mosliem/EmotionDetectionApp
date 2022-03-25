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
    @IBOutlet weak var topView: UIView!
    
    var chart = LineChartView()
    private var chartViewContainer = UIView()
    private let chartTitle = UILabel()
    
    var presenter : DashboardPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(View: self)
        configureProfileImageView()
        configureCurrentMoodView()
        configureMoodGraphView()
        configureChartTitle()
        configureTopView()
        configureFonts()
        
    }
    private func configureProfileImageView(){
        
        ProfileImageView.clipsToBounds = true
        ProfileImageView.layer.cornerRadius = 40
        
        //profile imageview container
        profileView.layer.cornerRadius = 40
        profileView.layer.shadowColor = UIColor.darkGray.cgColor
        profileView.layer.shadowOffset = CGSize.zero
        profileView.layer.shadowRadius = 10
        profileView.layer.shadowOpacity = 1.0
    }
    private func configureCurrentMoodView(){
        CurrentMoodView.layer.cornerRadius = 15
        CurrentMoodView.layer.shadowColor = UIColor.darkGray.cgColor
        CurrentMoodView.layer.shadowOffset = CGSize.zero
        CurrentMoodView.layer.shadowRadius = 10
        CurrentMoodView.layer.shadowOpacity = 0.9
    }
    
    private func configureMoodGraphView(){
        
        chartViewContainer.frame = CGRect(x: 15, y:CurrentMoodView.bottom + 200, width: view.bounds.width-30, height: 350)
        chart = LineChartView(frame: CGRect(x: 12.5, y:40, width: chartViewContainer.bounds.width-25, height: 300))
        
        // Rounded chart corner
        chart.clipsToBounds = true
        chart.backgroundColor = .clear
        chartViewContainer.layer.cornerRadius = 15
        
        // Getting data
        chart.data = presenter.getChartData()
        
        //subView
        view.addSubview(chartViewContainer)
        self.chartViewContainer.addSubview(chart)
        chartViewContainer.backgroundColor = .white
        
        // Shadow
        chartViewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        chartViewContainer.layer.shadowOffset = CGSize.zero
        chartViewContainer.layer.shadowRadius = 5
        chartViewContainer.layer.shadowOpacity = 1.0

        // Char Fonts
        chart.leftYAxisRenderer.axis.labelFont = .boldSystemFont(ofSize: 25)
        chart.leftYAxisRenderer.axis.labelAlignment = .right
        chart.xAxisRenderer.axis.labelFont = UIFont(name: "CircularStd-Black", size: 12)!
        chart.xAxisRenderer.axis.wordWrapEnabled = true
        chart.xAxisRenderer.axis.labelPosition = .bottomInside
        chart.rightAxis.drawLabelsEnabled = false
        chart.lineData?.setDrawValues(false)
        
        //animation
        chart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
        
        // Left axis emojis
        let leftAxis = chart.leftAxis
        leftAxis.labelCount = 4
        leftAxis.granularity = 1
        leftAxis.axisMinimum = 0
        leftAxis.axisLineWidth = 0
        
        leftAxis.valueFormatter = YAxisData()
        
        //x axis label
        let bottomAxis = chart.xAxis
        bottomAxis.labelCount = 7
        bottomAxis.granularity = 1
        bottomAxis.axisMinimum = 1
        bottomAxis.axisLineWidth = 0
        bottomAxis.valueFormatter = XAxisData()
        bottomAxis.labelHeight = 30
       
        //right side of Grid
        chart.xAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawZeroLineEnabled = false
        chart.rightAxis.axisLineColor = .clear
        chart.xAxis.axisLineWidth = 0
        chart.xAxis.setLabelCount(Int(chart.lineData!.xMax), force: true)
        let lenged = chart.legend
        lenged.enabled = false
        
        
    }
    
    private func configureChartTitle(){
        chartTitle.frame = CGRect(x: chartViewContainer.left+5, y: 10, width: view.bounds.width, height: 30)
        chartTitle.text = "Mood Chart"
        chartTitle.textColor = .black
        chartTitle.font = UIFont(name: "CircularStd-Black", size: 22)
        chartViewContainer.addSubview(chartTitle)
    }
    
    private func configureTopView(){
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowRadius = 40
        topView.layer.shadowOpacity = 1.0
        topView.layer.cornerRadius = 25
    }
    private func configureFonts(){
        NameLabel.font =  UIFont(name: "CircularStd-Black", size: 24)
        NameLabel.layer.shadowColor = UIColor.white.cgColor
        NameLabel.layer.shadowOffset = CGSize.zero
        NameLabel.layer.shadowRadius = 30
        NameLabel.layer.shadowOpacity = 0.7
        
        
    }
}
