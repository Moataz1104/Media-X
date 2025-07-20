//
//  SBStoryImage.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import Foundation

struct SBStoryImage : SupabaseUploadable {
    static var tableName: String {
        return Constants.STORIES_IMAGES_TABLE
    }
    
    
    var id:UUID
    var storyId:UUID
    var urlString:String
    var imageIndex:Int
    var isWatched:Bool? = nil
    enum CodingKeys : String, CodingKey {
        case id
        case storyId = "story_id"
        case urlString = "url_string"
        case imageIndex = "image_index"
        case isWatched = "is_watched"
    }
}
