//
//  ProfileManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

protocol ProfileManagerProtocol : UserIDFetchable {
    func fetchProfilePosts(userId:String)async throws -> [SBFetchedPost]
    func fetchFollowersCount(userId:UUID)async throws -> Result<Int, any Error>
    func fetchFollowingCount(userId:UUID)async throws -> Result<Int, any Error>
    func fetchPostsCount(userId:UUID)async throws -> Result<Int, any Error>
    func getBookmarks(userId:String) async throws -> [SBFetchedPost]
}




class ProfileManager : SupaBaseFunctions, ProfileManagerProtocol {
    
    func getBookmarks(userId:String) async throws -> [SBFetchedPost] {
        try await getMyBookmarks(userId: userId)
    }
    
    func fetchFollowersCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.FOLLOWERS_TABLE, columnName: "follower", filterValue: userId)
    }
    
    func fetchFollowingCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.FOLLOWERS_TABLE, columnName: "following", filterValue: userId)
    }
    
    func fetchPostsCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.POSTS_TABLE, columnName: "user_id", filterValue: userId)
    }
    
    
    func fetchProfilePosts(userId:String)async throws -> [SBFetchedPost] {
        try await getProfilePosts(userId: userId)
    }
    
}
