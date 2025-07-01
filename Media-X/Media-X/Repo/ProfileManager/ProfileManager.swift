//
//  ProfileManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

protocol ProfileManagerProtocol : UserIDFetchable {
    func fetchProfilePosts(userId:String)async throws -> [SBFetchedPost]
    
    
}




class ProfileManager : SupaBaseFunctions, ProfileManagerProtocol {
    
    
    func fetchProfilePosts(userId:String)async throws -> [SBFetchedPost] {
        try await getProfilePosts(userId: userId)
    }
    
}
