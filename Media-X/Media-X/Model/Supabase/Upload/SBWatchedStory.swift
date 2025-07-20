//
//  SBWatchedStory.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/07/2025.
//

import Foundation

struct SBWatchedStory :SupabaseUploadable{
    
    static var tableName: String {
        return Constants.WATCHED_STORIES_TABLE
    }
    
    var id: UUID
    var userId:UUID
    var storyImageId:UUID
    var createdAt:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case storyImageId = "story_image_id"
        case createdAt = "created_at"
    }
    
}
