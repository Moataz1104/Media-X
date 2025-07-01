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
    
    
    var tempUserName = ""
    var tempBio :String?
    var isMyProfile:Bool?

    private let manager:ProfileManagerProtocol
    
    init() {
        manager = ProfileManager()
    }
    
    @MainActor
    func fetchPosts(userId:String) async{
        
        do {
            async let posts = manager.fetchProfilePosts(userId: userId)
            async let c:Void = fetchCounts()
            async let bookmarks = try await getBookmarks()
            self.posts = try await posts
            self.bookmarks = try await bookmarks
            try await c
            
        }catch {
            print(error.localizedDescription)
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
        return try await manager.getBookmarks(userId: id.uuidString)
        
    }
    
    private func fetchCounts() async throws {
        guard let userId = manager.getUserId() else { return }
        
        async let followersResult = manager.fetchFollowersCount(userId: userId)
        async let followingResult = manager.fetchFollowingCount(userId: userId)
        async let postsResult = manager.fetchPostsCount(userId: userId)

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
}
