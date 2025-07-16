//
//  SearchViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import Foundation
import Combine

@MainActor
class SearchViewModel : ObservableObject {
    
    @Published var searchInput = ""
    @Published var searchResults : [SBUserModel] = []
    @Published var recentSearches : [SBUserModel] = []
    
    private let searchManager : SearchManagerProtocol
    private let followManager : FollowingProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        searchManager = SearchManager()
        followManager = ProfileManager()
        subscribeToSearchInput()
        fetchRecentSearches()
    }
    
    func removeRecent(searchedUser:UUID) {
        guard let userId = followManager.getUserUID() else {return}
        
        Task {
            do {
                let result = try await searchManager.removeRecentModel(currentUserId: userId, searchedUserId: searchedUser)
                if let index = self.recentSearches.firstIndex(where: {$0.id == searchedUser}) {
                    recentSearches.remove(at: index)
                }
                switch result {
                case .success(_):
                    print("removeRecentModel success")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadRecentSearch(userModel:SBUserModel) {
        guard let userId = followManager.getUserUID() else {return}
        guard self.recentSearches.contains(where: {$0.id == userModel.id}) == false else {return}
        let model = SBRecentSearch(
            id: UUID(),
            userId: userId,
            searchedUser: userModel.id
        )
        
        Task {
            do {
                let result = try await searchManager.uploadRecentSearch(model: model)
                switch result {
                case .success(_):
                    print("uploadRecentSearch success")
                    self.recentSearches.insert(userModel, at:0)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchRecentSearches() {
        guard let userId = followManager.getUserUID() else {return}
        Task {
            do {
                recentSearches = try await searchManager.fetchRecent(userId: userId)
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func subscribeToSearchInput() {
        $searchInput
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: {[weak self] value in
                guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      let self = self
                else {self?.searchResults = []; return}
                fetchSearchResults(input: value)
            })
            .store(in: &cancellables)
    }
    
    private func fetchSearchResults(input:String) {
        guard let id = followManager.getUserUID() else { return }
        
        Task {
            do {
                searchResults = try await searchManager.fetchSearchResults(userId: id.uuidString, searchInput: input)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func handleFollow (userId:String,isFollower:Bool) {
        Task {
            do {
                if isFollower {
                    try await unFollowUser(userId: userId)
                }else {
                    try await followUser(userId: userId)
                    if let uid = UUID(uuidString: userId) {
                        PostNotification.shared.uploadNotification(toUserId: uid, action: .follow)
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @MainActor
    private func followUser(userId:String) async throws{
        guard let currentUserId = followManager.getUserUID(),let uid = UUID(uuidString: userId) else {return}
        let model = SBFollower(id: UUID(), follower: currentUserId, following: uid)
        if let index = self.searchResults.firstIndex(where: {$0.id.uuidString == userId}) {
            self.searchResults[index].isFollower = true
        }
        let result = try await followManager.follow(model: model)
        switch result {
        case .success(_):
            print("follow success")
        case .failure(let failure):
            throw failure
        }
    }
    
    @MainActor
    private func unFollowUser(userId:String) async throws{
        guard let currentUserId = followManager.getUserUID(),let uid = UUID(uuidString: userId) else {return}
        if let index = self.searchResults.firstIndex(where: {$0.id.uuidString == userId}) {
            self.searchResults[index].isFollower = false
        }
        let result = try await followManager.unFollow(myId: currentUserId, otherUserId: uid)
        switch result {
        case .success(_):
            print("unFollow success")
        case .failure(let failure):
            throw failure
        }
    }
    
}
