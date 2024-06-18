//
//  ViewModel_Swipes.swift
//  DrivUs
//
//  Created by Natalie Schmitzberger on 21.05.24.
//

import Foundation

class ViewModel_Swipes: ObservableObject {
    @Published private (set) var model: Model.SwipeModel
    @Published var swipesCount: Int = 0
    
    init(_ model: Model.SwipeModel) {
        self.model = model
    }
    
    var swipes: [Model.SwipeModel.Swipe] {
        model.swipes
    }
    
    func setSwipes(_ swipes: [Model.SwipeModel.Swipe]) {
        model.setSwipes(swipes)
    }
    
    func fetchUserSwipes(_ user: Model.UserModel.User) {
        setSwipes(MatchManager.shared.filterSwipesByUser(swipes, user))
    }
    
    func fetchAllSwipes() {
        SwipesService.shared.fetchAllSwipes { [weak self] swipes in
            DispatchQueue.main.async {
                self?.setSwipes(swipes ?? [])
            }
        }
    }

    func getSwipesCount(for userId: String) -> Int {
        return swipes.filter { $0.firstUserId == userId || $0.secondUserId == userId }.count
    }
    
    func answerSwipe(swipeId: String, answer: Bool, user: Model.UserModel.User) {
        SwipesService.shared.updateSwipe(swipeId, answer, user) { success in
            if success {
                print("")
                print("updated swipe")
                print("")
            }
            else {
                print("")
                print("failed at updating swipe")
                print("")
            }
        }
    }
}
