//
//  DashboardVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/12/22.
//

import UIKit
import Charts
class DashboardVC: UIViewController,ChartViewDelegate {
    
    @IBOutlet weak var dashboardScrollView: UIScrollView!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var currentMoodImageView: UIImageView!
    @IBOutlet weak var currentMoodLabel: UILabel!
    @IBOutlet weak var CurrentMoodView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var topView: UIView!
    private var lastContentOffset: CGFloat = 0
    
    //DateLabel
    private let dateLabel = UILabel()
    private let increasingDateBtn = UIButton()
    private let decreasingDateBtn = UIButton()
    
    //line Chart
    private var lineChart = LineChartView()
    private var lineChartViewContainer = UIView()
    private let lineChartTitle = UILabel()
    
    //Pie Chart
    private var moodCountPieChart = PieChartView()
    private let pieChartContainerView = UIView()
    private let pieChartTitle = UILabel()
    
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
        configureMoodCountPieChart()
        configurePieChartTitle()
        configureDateSwitcher()
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
    
    
    func configureMoodGraphView(){
        
        lineChartViewContainer.frame = CGRect(x: 15, y:CurrentMoodView.bottom + 270, width: view.bounds.width-30, height: 350)
        lineChart.frame =  CGRect(x: 12.5, y:40, width: lineChartViewContainer.bounds.width-25, height: 300)
        
        // Rounded chart corner
        lineChart.clipsToBounds = true
        lineChart.backgroundColor = .clear
        lineChartViewContainer.layer.cornerRadius = 15
        
        // Getting data
        lineChart.data = presenter.getLineChartData()
        
        //subView
        dashboardScrollView.addSubview(lineChartViewContainer)
        self.lineChartViewContainer.addSubview(lineChart)
        lineChartViewContainer.backgroundColor = .white
        
        // Shadow
        lineChartViewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        lineChartViewContainer.layer.shadowOffset = CGSize.zero
        lineChartViewContainer.layer.shadowRadius = 5
        lineChartViewContainer.layer.shadowOpacity = 1.0
        
        // Char Fonts
        lineChart.leftYAxisRenderer.axis.labelFont = .boldSystemFont(ofSize: 25)
        lineChart.leftYAxisRenderer.axis.labelAlignment = .right
        lineChart.xAxisRenderer.axis.labelFont = UIFont(name: "CircularStd-Black", size: 12)!
        lineChart.xAxisRenderer.axis.wordWrapEnabled = true
        lineChart.xAxisRenderer.axis.labelPosition = .bottomInside
        lineChart.rightAxis.drawLabelsEnabled = false
        lineChart.lineData?.setDrawValues(false)
        
        //animation
        lineChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
        // Left axis emojis
        let leftAxis = lineChart.leftAxis
        leftAxis.forceLabelsEnabled = true
        leftAxis.labelCount = 4
        leftAxis.granularity = 0
        leftAxis.axisMinimum = 0
        leftAxis.axisLineWidth = 0
        leftAxis.valueFormatter = YAxisData()
        
        //x axis label
        let bottomAxis = lineChart.xAxis
        bottomAxis.labelCount = 7
        bottomAxis.granularity = 1
        bottomAxis.axisMinimum = 1
        bottomAxis.axisLineWidth = 0
        bottomAxis.valueFormatter = XAxisData()
        bottomAxis.labelHeight = 30
        
        //right side of Grid
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawZeroLineEnabled = false
        lineChart.rightAxis.axisLineColor = .clear
        lineChart.xAxis.axisLineWidth = 0
        lineChart.xAxis.setLabelCount(Int(lineChart.lineData!.xMax), force: true)
        let lenged = lineChart.legend
        lenged.enabled = false
        
    }
    
    private func configureChartTitle() {
        
        lineChartTitle.frame = CGRect(
            x: lineChartViewContainer.left+5,
            y: 10,
            width: view.bounds.width,
            height: 30
        )
        
        lineChartTitle.text = "Mood Chart"
        lineChartTitle.textColor = .black
        lineChartTitle.font = UIFont(name: "CircularStd-Black", size: 22)
        lineChartViewContainer.addSubview(lineChartTitle)
        
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
    
    
    private func configureMoodCountPieChart() {
        
        //setting the frames
        pieChartContainerView.frame = CGRect(x: 15, y: lineChartViewContainer.bottom+50 , width: view.bounds.width-30, height: 400)
        moodCountPieChart.frame = CGRect(x: 7.5, y: 50, width: pieChartContainerView.width-15, height: 300)
        
        // rounded view corner
        moodCountPieChart.clipsToBounds = true
        pieChartContainerView.layer.cornerRadius = 15
        pieChartContainerView.backgroundColor = .white
        moodCountPieChart.data = presenter.getPieChartData()
        
        //Sub view
        dashboardScrollView.addSubview(pieChartContainerView)
        self.pieChartContainerView.addSubview(moodCountPieChart)
        
        //shadow for view
        let container = pieChartContainerView.layer
        container.shadowColor = UIColor.lightGray.cgColor
        container.shadowOffset = CGSize.zero
        container.shadowRadius = 5
        container.shadowOpacity = 1.0
        
        //moodCountPieChart.entryLabelFont = 
        moodCountPieChart.legend.enabled = false
        moodCountPieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        moodCountPieChart.sizeToFit()
    }
    
    
    func configurePieChartTitle(){
        
        pieChartTitle.text = "Mood Counts"
        pieChartTitle.frame = CGRect(x: pieChartContainerView.left+5, y: 15, width: view.bounds.width, height: 30)
        pieChartTitle.textColor = .black
        pieChartTitle.font = UIFont(name: "CircularStd-Black", size: 22)
        self.pieChartContainerView.addSubview(pieChartTitle)
        
    }
    
    func configureDateSwitcher(){
        dateLabel.frame = CGRect(x: view.center.x - 90, y: lineChartViewContainer.top - 60, width: 180, height: 40)
        dateLabel.font = UIFont(name: "CircularStd-Bold", size: 20)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .white
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = 15
        
        //currentDate
        dateLabel.text = presenter.getcurrentWeekDate()
        
        //right button
        configureDateRightButton()
        
        //left button
        configureDateLeftButton()
        
        //subviews
        dashboardScrollView.addSubview(dateLabel)
        
        increasingDateBtn.addTarget(self, action: #selector(increasePressed), for: .touchUpInside)
        decreasingDateBtn.addTarget(self, action: #selector(decreasePressed), for: .touchUpInside)
    }
    
    
    func configureDateRightButton() {
        
        increasingDateBtn.frame = CGRect(
            x: dateLabel.right + 3,
            y: lineChartViewContainer.top - 52,
            width: 25,
            height: 25
        )
        
        var rightBtnTintImage = UIImage(named: "rightButton")
        rightBtnTintImage = rightBtnTintImage?.withRenderingMode(.alwaysTemplate)
        increasingDateBtn.setImage(rightBtnTintImage, for: .normal)
        increasingDateBtn.tintColor = .blue
        dashboardScrollView.addSubview(increasingDateBtn)
        
        
    }
    
    
    func configureDateLeftButton(){
        
        decreasingDateBtn.frame = CGRect(
            x: dateLabel.left - 28,
            y: lineChartViewContainer.top - 52,
            width: 25,
            height: 25
        )
        
        decreasingDateBtn.backgroundColor = .clear
        var tintImage = UIImage(named:"leftButton")
        tintImage = tintImage?.withRenderingMode(.alwaysTemplate)
        decreasingDateBtn.setImage(tintImage, for: .normal)
        decreasingDateBtn.tintColor = .blue
        dashboardScrollView.addSubview(decreasingDateBtn)
        
    }
    
    
    @objc func increasePressed()
    {
        dateLabel.text = presenter.increasingDatePressed()
    }
    
    @objc func decreasePressed()
    {
        dateLabel.text = presenter.decreasingDatePressed()
    }
    
}






