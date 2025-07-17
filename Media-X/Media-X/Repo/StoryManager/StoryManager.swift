//
//  StoryManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/07/2025.
//

import Foundation

protocol StoryManagerProtocol :UserIDFetchable{
    
    func fetchMyStory(userId:UUID)async throws -> Result<[SBStory], any Error>
    func fetchStoryDetails(userId:UUID) async throws-> [SBStoryDetails]
    func getStories(userId:UUID) async throws-> [SBUserModel]
}

class StoryManager :SupaBaseFunctions , StoryManagerProtocol{
    
    func getStories(userId:UUID) async throws-> [SBUserModel] {
        try await getUsersStories(userId: userId)
    }
    
    func fetchStoryDetails(userId:UUID) async throws-> [SBStoryDetails]{
        try await getStoryDetails(userId: userId)
    }
    
    func fetchMyStory(userId:UUID)async throws -> Result<[SBStory], any Error> {
        try await fetchModelById(id: userId, culomnIdName: "user_id")
    }
    
}

