//
//  StoryManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/07/2025.
//

import Foundation

protocol StoryManagerProtocol :UserIDFetchable{
    
    func fetchMyStory(userId:UUID)async throws -> Result<[SBStory], any Error>
    func fetchStoryDetails(userId:UUID,currentUserId:UUID) async throws-> [SBStoryDetails]
    func getStories(userId:UUID) async throws-> [SBUserModel]
}

protocol StoryWatchable : UserIDFetchable {
    func uploadWatchModel(model:SBWatchedStory)async throws -> Result<Void, any Error>
    func fetchStoryViewers(imageId: UUID) async throws -> [SBUserModel]
}

class StoryManager :SupaBaseFunctions , StoryManagerProtocol,StoryWatchable{
    
    func fetchStoryViewers(imageId: UUID) async throws -> [SBUserModel] {
        try await getStoryViewers(imageId: imageId)
    }
    
    func uploadWatchModel(model:SBWatchedStory)async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    func getStories(userId:UUID) async throws-> [SBUserModel] {
        try await getUsersStories(userId: userId)
    }
    
    func fetchStoryDetails(userId:UUID,currentUserId:UUID) async throws-> [SBStoryDetails]{
        try await getStoryDetails(userId: userId,currentUserId:currentUserId)
    }
    
    func fetchMyStory(userId:UUID)async throws -> Result<[SBStory], any Error> {
        try await fetchModelById(id: userId, culomnIdName: "user_id")
    }
    
}

