//
//  SBStory.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import Foundation

struct SBStory :SupabaseUploadable {
    
    static var tableName: String {
        return Constants.STORIES_TABLE
    }
    
    var id : UUID
    var userId:UUID
    var createdAt:String?
    var text:String
    
    enum CodingKeys : String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case text
    }
}
