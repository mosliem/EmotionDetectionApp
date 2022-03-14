//
//  CallAnalysisVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import UIKit

class CallAnalysisVC: UIViewController {
    
    private let searchController : UISearchController = {
        let searchVC = UISearchController(searchResultsController: SearchResultVC())
        searchVC.searchBar.placeholder = "Call Analysis"
        searchVC.searchBar.barStyle = .default
        searchVC.definesPresentationContext = true
        
        return searchVC
    }()
    
    private let recordedCallCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
            return CallAnalysisVC.createRecordedCallsCollection(section: section)
        }))
        
    var presenter : CallAnalysisPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CallAnalysisPresenter(View: self)
        configureSearchController()
        configureCallsCollection()
        view.backgroundColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.searchController = searchController
        recordedCallCollectionView.frame = view.bounds
    }
    
    private func configureSearchController(){
 
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Recorded Calls"
    }
    
    
    private static func createRecordedCallsCollection(section : Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 6 , leading: 6, bottom: 6, trailing: 6)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func configureCallsCollection(){
     
        self.view.addSubview(self.recordedCallCollectionView)
        recordedCallCollectionView.delegate = self
        recordedCallCollectionView.dataSource = self
        
        recordedCallCollectionView.register(
            recordedCallCell.self,
            forCellWithReuseIdentifier: recordedCallCell.identifier
        )
        recordedCallCollectionView.backgroundColor = .white
    }

}

extension CallAnalysisVC :  UISearchResultsUpdating ,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


extension CallAnalysisVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return presenter.getCallsNumber()
    return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordedCallCollectionView.dequeueReusableCell(withReuseIdentifier:recordedCallCell.identifier, for: indexPath) as! recordedCallCell
        cell.configure(model:presenter.configureRecordedCallModel(),index : indexPath.row)
        return cell
    }
}
