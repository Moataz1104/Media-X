//
//  StoryViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/07/2025.
//

import Foundation
import SwiftUI

@MainActor
class StoryViewModel :ObservableObject{
    
    private let manager:StoryManagerProtocol
    @Published var userStoires : [SBUserModel] = []
    @Published var ihaveStory : Bool = false
    @Published var storyLoadingId : UUID?
    @Published var storyDetails : [SBStoryDetails] = []
    
    
    
    init() {
        manager = StoryManager()
        fetchStories()
    }
    
    func refresh() {
        fetchStories()
    }
    
    func getStoryDetails(userId:UUID) {
        guard let currentUserId = manager.getUserId() else { return }
        storyLoadingId = userId
        
        Task {
            do {
                
                let data = try await manager.fetchStoryDetails(userId: userId,currentUserId:currentUserId)
                
                withAnimation {
                    storyDetails = data
                }
            }catch {
                print(error.localizedDescription)
            }
            storyLoadingId = nil
        }
        
    }
    
    private func fetchStories() {
        guard let userId = manager.getUserId() else { return }

        Task {
            do {
                async let userStoriesResult = manager.getStories(userId: userId)
                async let myStoryResult : Void = fetchMyStory()

                userStoires = try await userStoriesResult
                try await myStoryResult
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func fetchMyStory() async throws{
        guard let userId = manager.getUserId() else {return}
        
        let result = try await manager.fetchMyStory(userId: userId)
        
        switch result {
        case .success(let data):
            ihaveStory = !data.isEmpty
        case .failure(let failure):
            throw failure
        }
    }
    
}

