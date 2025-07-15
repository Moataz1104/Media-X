//
//  ProfileViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

class ProfileViewModel : ObservableObject {
    @Published var showImagePicker = false
    @Published var isEditingProfile = false
    
    @Published var selectedTab: TabType = .photos
    @Published var imageData: Data?
    
    @Published var username = ""
    @Published var imageId:String?
    @Published var userId:String?
    @Published var posts:[SBFetchedPost] = []
    @Published var bookmarks:[SBFetchedPost] = []
    @Published var followersCount = 0
    @Published var followingCount = 0
    @Published var postsCount = 0
    @Published var isFollower:Bool?
    
    var tempUserName = ""
    var tempBio :String?
    var isMyProfile:Bool?

    private let manager:ProfileManagerProtocol
    
    init() {
        manager = ProfileManager()
    }
    
    @MainActor
    func fetchPosts(userId:String) async{
        guard let isMyProfile = isMyProfile,let currentUserId = manager.getUserId(),
        let uid = UUID(uuidString: userId)
        else {return}
        do {
            async let posts = manager.fetchProfilePosts(userId: userId, currentUserId: currentUserId.uuidString)
            async let c:Void = fetchCounts(userId:userId)
            if isMyProfile {
                async let bookmarks = try await getBookmarks()
                self.bookmarks = try await bookmarks
            }else {
                async let check:Void = self.checkIfFollower(userId: uid)
                try await check
            }
            self.posts = try await posts
            try await c
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    func getUserData(userId:UUID)async throws -> SBUserModel? {
        
        let result = try await manager.fetchUserData(userId: userId)
        switch result {
        case .success(let data):
            if let user = data.first {
                return user
            }else {
                return nil 
            }
        case .failure(let failure):
            throw failure
        }
        
        
    }
    
    func isMyProfile(id:String) -> Bool {
        if let uid = UUID(uuidString: id), let userId = manager.getUserId() {
            return uid == userId
        }
        return false
    }
    
    private func getBookmarks()async throws -> [SBFetchedPost] {
        guard let id = manager.getUserId() else { return [] }
        print(id.uuidString)
        return try await manager.getBookmarks(userId: id.uuidString)
        
    }
    
    private func fetchCounts(userId:String) async throws {
        guard let uid = UUID(uuidString: userId) else{return}
        async let followersResult = manager.fetchFollowersCount(userId: uid)
        async let followingResult = manager.fetchFollowingCount(userId: uid)
        async let postsResult = manager.fetchPostsCount(userId: uid)

        let (followers, following, posts) = try await (followersResult, followingResult, postsResult)
        
        
        switch followers {
        case .success(let count):
            await MainActor.run {
                self.followersCount = count
            }
        case .failure(let error):
            throw error
        }
        
        switch following {
        case .success(let count):
            await MainActor.run {
                self.followingCount = count
            }
        case .failure(let error):
            throw error
        }
        
        switch posts {
        case .success(let count):
            await MainActor.run {
                self.postsCount = count
            }
        case .failure(let error):
            throw error
        }
    }
    
    @MainActor
    private func checkIfFollower(userId:UUID) async throws{
        guard let currentUserId = manager.getUserUID() else {return}
        
        let result = try await manager.fetchFollowState(myId: currentUserId, otherUserId: userId)
        
        switch result {
        case .success(let data):
            if data.isEmpty {
                self.isFollower = false
            }else {
                self.isFollower = true
            }
        case .failure(let failure):
            throw failure
        }
        
    }
    
    
    func handleFollow () {
        guard let userId = self.userId else {return}
        guard let isFollower = isFollower else {return}
        
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
        self.isFollower = true
        self.followersCount += 1
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
        self.isFollower = false
        self.followersCount -= 1
        let result = try await manager.unFollow(myId: currentUserId, otherUserId: uid)
        switch result {
        case .success(_):
            print("unFollow success")
        case .failure(let failure):
            throw failure
        }
    }
    
}
