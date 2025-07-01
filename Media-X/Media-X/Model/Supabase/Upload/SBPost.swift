//
//  SBPost.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import Foundation

struct SBPost :SupabaseUploadable {
    static var tableName: String {
        return Constants.POSTS_TABLE
    }
    
    
    var id:UUID
    var userId:UUID
    var caption:String
    var dateString:String
    
    enum CodingKeys : String, CodingKey {
        case id
        case userId = "user_id"
        case caption
        case dateString = "date_string"
    }
    
}
