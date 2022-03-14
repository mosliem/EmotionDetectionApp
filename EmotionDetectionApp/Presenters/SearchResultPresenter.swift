//
//  SearchResultPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import Foundation

class SearchResultPresenter {
    weak var View: SearchResultVC!
    var searchResults = [RecordedCallModel]()
    
    init(View: SearchResultVC) {
        self.View = View
    }
    
    func getSearchResults(){
    
    }
    func configureSearchModel() -> [RecordedCallModel]{
        return searchResults
    }
    func getSearchResultNumber()-> Int{
        View.UpdateCollectionData()

        return searchResults.count
    }
}

