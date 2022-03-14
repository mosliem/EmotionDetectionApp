//
//  SearchResultVC.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import UIKit

class SearchResultVC: UIViewController {

    
    private let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
            return SearchResultVC.createCallsSearchResultCollection(section: section)
        }))
    
    var presenter: SearchResultPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter = SearchResultPresenter(View: self)
        configureCallsCollection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
  
    private static func createCallsSearchResultCollection(section : Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 6 , leading: 6, bottom: 6, trailing: 6)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func configureCallsCollection(){
     
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.backgroundColor = .white
        searchResultCollectionView.register(
            recordedCallCell.self,
            forCellWithReuseIdentifier: recordedCallCell.identifier
        )
    }
    
    func UpdateCollectionData(){
        searchResultCollectionView.reloadData()
    }
}

extension SearchResultVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return presenter.getCallsNumber()
    return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:recordedCallCell.identifier, for: indexPath) as! recordedCallCell
        cell.configure(model:presenter.configureSearchModel(),index : indexPath.row)
        return cell
    }
}
