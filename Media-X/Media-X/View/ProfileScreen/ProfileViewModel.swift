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
            let posts = try await manager.fetchProfilePosts(userId: userId)
            self.posts = posts
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
}
