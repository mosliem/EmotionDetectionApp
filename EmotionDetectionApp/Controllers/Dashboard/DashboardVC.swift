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
    private var chartViewContainer = UIView()
    private let chartTitle = UILabel()
    var RecommendationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
        return DashboardVC.createCollectionViewSection(section: section)
    }))
    
    
    var presenter : DashboardPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(View: self)
        configureProfileImageView()
        configureCurrentMoodView()
        configureMoodGraphView()
        confiureRecCollectionView()
        configureChartTitle()
        
        
      //  view.backgroundColor = UIColor(patternImage: UIImage(named: "")!)

    }
    private func configureProfileImageView(){
        
        ProfileImageView.clipsToBounds = true
        ProfileImageView.layer.cornerRadius = 40
        
        //profile imageview container
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
    
    private func configureMoodGraphView(){
        
        chartViewContainer.frame = CGRect(x: 30, y:CurrentMoodView.bottom + 100, width: view.bounds.width-60, height: 300)
        chart = LineChartView(frame: CGRect(x: 0, y:0, width: chartViewContainer.bounds.width, height: 300))
        
        //rounded chart corner
        chart.clipsToBounds = true
        chart.layer.cornerRadius = 20
        chart.backgroundColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.94, alpha: 1.0)
        chartViewContainer.layer.cornerRadius = 20
        
        //getting data
        chart.data = presenter.getChartData()
        view.addSubview(chartViewContainer)
        self.chartViewContainer.addSubview(chart)
        
        //shadow
        chartViewContainer.layer.shadowColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.94, alpha: 1.0).cgColor
        chartViewContainer.layer.shadowOffset = CGSize.zero
        chartViewContainer.layer.shadowRadius = 20
        chartViewContainer.layer.shadowOpacity = 1.0
    }
    
    private func confiureRecCollectionView(){
        RecommendationCollectionView.delegate = self
        RecommendationCollectionView.dataSource = self
        RecommendationCollectionView.backgroundColor = .clear
        RecommendationCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.identifier)
        RecommendationCollectionView.frame = CGRect(x: 10, y: chartViewContainer.bottom+50, width: view.bounds.width-20, height: 80)
        view.addSubview(RecommendationCollectionView)
    }
    
    private func configureChartTitle(){
        chartTitle.frame = CGRect(x: chartViewContainer.left-5, y: chartViewContainer.top-40, width: view.bounds.width, height: 30)
        chartTitle.text = "Daily Mood Chart"
        chartTitle.textColor = .black
        chartTitle.font = .systemFont(ofSize: 22, weight: .bold)
        view.addSubview(chartTitle)
    }
}

extension DashboardVC : UICollectionViewDelegate,UICollectionViewDataSource{

    
    static private func createCollectionViewSection(section:Int) ->NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension:.absolute(80)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3 , bottom: 0, trailing: 3)
        
        // group

        let horizontalGroup = NSCollectionLayoutGroup
            .vertical(
                layoutSize: NSCollectionLayoutSize(

                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)),
                subitem:item,
                count: 1)
        //section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = RecommendationCollectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCell.identifier, for: indexPath) as! RecommendationCell
        return cell
    }
}
