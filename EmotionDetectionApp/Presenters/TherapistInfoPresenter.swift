//
//  TherapistInfoPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/18/22.
//

import Foundation

class TherapistInfoPresenter {
    
    let View: TherapistInfoVC!
    var Therapists = [AvailableTherapistModel]()
    var selectedTherapistIndex : Int = 0
    init(View: TherapistInfoVC) {
        self.View = View
    }
    
    func getAvailableTherapistsInfo() {
        ChatFirestoreManager.shared.getAvailableTherapist { (result) in
            switch result{
            case .success(let model):
                self.Therapists = model
                self.View.reloadTheData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureTherapistModel() -> [AvailableTherapistModel] {
        return Therapists
    }
    func didSelectTherapist(indexPath : IndexPath){
        self.selectedTherapistIndex = indexPath.row
        View.viewChatVC()
    }
    func getTherapitsNumber() -> Int{
        return Therapists.count
    }
    
    func getTherapistName() -> String{
        return Therapists[selectedTherapistIndex].name
    }
    
    func getTherapistMail() -> String {
        return Therapists[selectedTherapistIndex].email
    }
}
