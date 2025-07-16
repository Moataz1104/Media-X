//
//  SBRecentSearch.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import Foundation

struct SBRecentSearch : SupabaseUploadable {
    
    static var tableName: String {
        return Constants.RECENT_SEARCHS_TABLE
    }
    
    var id:UUID
    var createdAt:String?
    var userId:UUID
    var searchedUser : UUID
    
    
    enum CodingKeys : String, CodingKey {
        case id
        case createdAt = "created_at"
        case userId = "user_id"
        case searchedUser = "searched_user"
    }
}
