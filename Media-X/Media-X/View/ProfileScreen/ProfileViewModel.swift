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
    var tempUserName = ""
    var tempBio :String?
    var isMyProfile:Bool?

    private let manager:ProfileManagerProtocol
    
    init() {
        manager = ProfileManager()
    }
    
    
    func isMyProfile(id:String) -> Bool {
        if let uid = UUID(uuidString: id), let userId = manager.getUserId() {
            return uid == userId
        }
        return false
    }
}
