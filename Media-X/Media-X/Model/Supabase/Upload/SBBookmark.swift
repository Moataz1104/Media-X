//
//  SBBookmark.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

struct SBBookmark : SupabaseUploadable {
    static var tableName: String {
        return Constants.BOOKMAR_TABLE
    }
    
    var id:UUID
    var postId:UUID
    var userId:UUID
    
    enum CodingKeys : String, CodingKey {
        case id
        case postId = "post_id"
        case userId = "user_id"
    }
}
