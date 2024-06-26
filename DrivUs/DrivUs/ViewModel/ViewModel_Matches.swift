//
//  ViewModel_Matches.swift
//  DrivUs
//
//  Created by MacBook on 30.04.24.
//

import Foundation

class ViewModel_Matches: ObservableObject {
    @Published private(set) var model: Model.MatchModel
    @Published private (set) var newMatchFound: Model.MatchModel.Match? = nil
    
    init(_ model: Model.MatchModel) {
        self.model = model
    }
    
    var matches: [Model.MatchModel.Match] {
        model.matches
    }
    
    func setMatches(_ matches: [Model.MatchModel.Match]) {
        print("matches setted\(matches)")
        model.setMatches(matches)
    }
    
    func fetchAllMatches() {
        MatchesService.shared.fetchAllMatches { [weak self] matches in
            DispatchQueue.main.async {
                self?.setMatches(matches ?? [])
            }
        }
    }
    
    func getMatchesCount(for userId: String) -> Int {
        return matches.filter { $0.firstUserId == userId || $0.secondUserId == userId }.count
    }
    
    func fetchUserMatches(_ user: Model.UserModel.User) {
        setMatches(MatchManager.shared.filterMatchesByUser(matches, user))
    }
    
    func addNewMatchToAlreadyExistingMatches(_ newMatch: Model.MatchModel.Match) {
        var newMatches: [Model.MatchModel.Match] = matches
        newMatches.append(newMatch)
        
        setMatches(newMatches)
    }
}
