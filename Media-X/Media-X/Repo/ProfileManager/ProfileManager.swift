//
//  ProfileManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

protocol ProfileManagerProtocol : UserIDFetchable,FollowingProtocol {
    func fetchProfilePosts(userId:String,currentUserId:String)async throws -> [SBFetchedPost]
    func fetchFollowersCount(userId:UUID)async throws -> Result<Int, any Error>
    func fetchFollowingCount(userId:UUID)async throws -> Result<Int, any Error>
    func fetchPostsCount(userId:UUID)async throws -> Result<Int, any Error>
    func getBookmarks(userId:String) async throws -> [SBFetchedPost]
    func fetchUserData(userId:UUID) async throws -> Result<[SBUserModel], any Error>
}

protocol FollowingProtocol:UserIDFetchable {
    func fetchFollowState(myId:UUID,otherUserId:UUID)async throws -> Result<[SBFollower], any Error>
    func follow(model:SBFollower) async throws -> Result<Void, any Error>
    func unFollow(myId:UUID,otherUserId:UUID) async throws -> Result<Void, any Error>
    func getFollowers(userId:UUID, myId:UUID) async throws -> [SBUserModel]
    func getFollowings(userId:UUID, myId:UUID) async throws -> [SBUserModel]
}



class ProfileManager : SupaBaseFunctions, ProfileManagerProtocol{
    
    

    func getFollowers(userId:UUID, myId:UUID) async throws -> [SBUserModel] {
        try await getUserFollowers(userId: userId, my_id: myId)
        
    }
    
    func getFollowings(userId:UUID, myId:UUID) async throws -> [SBUserModel] {
        try await getUserFollowings(userId: userId,my_id:myId)
        
    }
    
    func follow(model:SBFollower) async throws -> Result<Void, any Error>{
        try await uploadModel(model)
    }
    
    func unFollow(myId:UUID,otherUserId:UUID) async throws -> Result<Void, any Error>{
        try await deleteModel(
            column1Name: "follower",
            column1Value: myId,
            column2Name: "following",
            column2Value: otherUserId,
            tableName: Constants.FOLLOWERS_TABLE
        )
    }
    
    
    func fetchFollowState(myId:UUID,otherUserId:UUID)async throws -> Result<[SBFollower], any Error>  {
        try await fetchModelByTwoFilters(
            filter1: myId,
            filter2: otherUserId,
            columnName1: "follower",
            columnName2: "following"
        )
    }
    
    func fetchUserData(userId:UUID) async throws -> Result<[SBUserModel], any Error> {
        try await fetchModelById(id: userId, culomnIdName: "id")
    }
    
    func getBookmarks(userId:String) async throws -> [SBFetchedPost] {
        try await getMyBookmarks(userId: userId)
    }
    
    func fetchFollowersCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.FOLLOWERS_TABLE, columnName: "following", filterValue: userId)
    }
    
    func fetchFollowingCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.FOLLOWERS_TABLE, columnName: "follower", filterValue: userId)
    }
    
    func fetchPostsCount(userId:UUID)async throws -> Result<Int, any Error> {
        try await fetchRowCount(tableName: Constants.POSTS_TABLE, columnName: "user_id", filterValue: userId)
    }
    
    
    func fetchProfilePosts(userId:String,currentUserId:String)async throws -> [SBFetchedPost] {
        try await getProfilePosts(userId: userId, currentUserId: currentUserId)
    }
    
}
