//
//  FollowersViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 03/07/2025.
//

import Foundation
import Combine

@MainActor
class FollowersViewModel: ObservableObject {
    
    @Published var searchInput: String = ""
    @Published var filteredUsers = [SBUserModel]()
    private var users:[SBUserModel] = [] {
        didSet {
            filteredUsers = users
        }
    }
    var screenState :FollowersScreenState = .followers
    var userId:String?
    private let manager: FollowingProtocol
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        manager = ProfileManager()
        subscribeToSearchInput()
    }
    
    
    
    @MainActor
    func getUsers() {
        guard let userId = userId,let uid = UUID(uuidString: userId),let myId = manager.getUserUID() else { return }
        
        Task {
            do {
                switch screenState {
                case .followers:
                    self.users = try await manager.getFollowers(userId: uid, myId: myId)
                case .followings:
                    self.users = try await manager.getFollowings(userId: uid, myId: myId)
                }
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
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @MainActor
    private func followUser(userId:String) async throws{
        guard let currentUserId = manager.getUserUID(),let uid = UUID(uuidString: userId) else {return}
        let model = SBFollower(id: UUID(), follower: currentUserId, following: uid)
        if let index = self.users.firstIndex(where: {$0.id.uuidString == userId}) {
            self.users[index].isFollower = true
        }
        let result = try await manager.follow(model: model)
        switch result {
        case .success(_):
            print("follow success")
        case .failure(let failure):
            throw failure
        }
    }
    
    @MainActor
    private func unFollowUser(userId:String) async throws{
        guard let currentUserId = manager.getUserUID(),let uid = UUID(uuidString: userId) else {return}
        if let index = self.users.firstIndex(where: {$0.id.uuidString == userId}) {
            self.users[index].isFollower = false
        }
        let result = try await manager.unFollow(myId: currentUserId, otherUserId: uid)
        switch result {
        case .success(_):
            print("unFollow success")
        case .failure(let failure):
            throw failure
        }
    }
    
    private func subscribeToSearchInput() {
        $searchInput.sink {[weak self] input in
            guard let self = self else{return}
            if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                filteredUsers = users
            }else {
                filteredUsers = users.filter({ $0.name.lowercased().contains(input.lowercased()) })
            }
        }
        .store(in: &cancellables)
    }
}

enum FollowersScreenState :String,Hashable{
    case followers = "Followers"
    case followings = "Followings"
}
