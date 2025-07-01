//
//  SBPostImage.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import Foundation

struct SBPostImage : SupabaseUploadable {
    static var tableName: String {
        return Constants.POSTS_IMAGES_TABLE
    }
    
    
    var id:UUID
    var postId:UUID
    var urlString:String
    var imageIndex:Int
    
    enum CodingKeys : String, CodingKey {
        case id
        case postId = "post_id"
        case urlString = "url_string"
        case imageIndex = "image_index"
    }
}
