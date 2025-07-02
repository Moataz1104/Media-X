//
//  SBComment.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

struct SBComment : SupabaseUploadable {
    static var tableName: String {
        return Constants.COMMENTS_TABLE
    }
    
    
    var id:UUID
    var parentId:UUID?
    var comment:String
    var userId:UUID
    var postId:UUID
    var dateString:String
    
    enum CodingKeys : String, CodingKey {
        case id
        case parentId = "parent_id"
        case comment
        case userId = "user_id"
        case postId = "post_id"
        case dateString = "date_string"
    }
}
