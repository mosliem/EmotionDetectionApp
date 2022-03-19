//
//  TherapistInfoVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit


class TherapistInfoVC: UIViewController {

    
    private let TherapistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
            return TherapistInfoVC.createTherapistCollection(section: section)
        }))
    
    var presenter: TherapistInfoPresenter!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TherapistInfoPresenter(View: self)
        configreCollectionView()
        view.backgroundColor = .white
        title = "Available Therapists"
        presenter.getAvailableTherapistsInfo()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    
    private func configreCollectionView(){
        TherapistCollectionView.register(TherapisInfoCell.self, forCellWithReuseIdentifier: TherapisInfoCell.identifer)
        view.addSubview(TherapistCollectionView)
        TherapistCollectionView.dataSource = self
        TherapistCollectionView.delegate = self
        TherapistCollectionView.frame = view.bounds
        TherapistCollectionView.backgroundColor = .white
    }
    
    private static func createTherapistCollection(section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension:.absolute(200)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        // group
        let verticalGroup = NSCollectionLayoutGroup
            .vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200)),
                subitem: item,
                count: 1
            )
        //section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return section
    }
    
    func reloadTheData(){
        TherapistCollectionView.reloadData()
    }
}


extension TherapistInfoVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getTherapitsNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TherapisInfoCell.identifer, for: indexPath) as! TherapisInfoCell
        let model = presenter.configureTherapistModel()
        cell.configure(model: model , indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.8
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            cell?.alpha = 1
        }
        presenter.didSelectTherapist(indexPath: indexPath)
    }
    
    
    func viewChatVC(){
        
        let vc = TherapistChatVC()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = presenter.getTherapistName()
        vc.therapistEmail = presenter.getTherapistMail()
    }
}


