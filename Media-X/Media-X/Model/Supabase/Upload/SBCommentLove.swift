//
//  SBCommentLove.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

struct SBCommentLove : SupabaseUploadable {
    
    static var tableName: String {
        return Constants.COMMENTS_LOVE_TABLE
    }
    
    
    var id : UUID
    var commentId : UUID
    var userId:UUID
    
    enum CodingKeys : String, CodingKey {
        case id
        case commentId = "comment_id"
        case userId = "user_id"
    }
}
