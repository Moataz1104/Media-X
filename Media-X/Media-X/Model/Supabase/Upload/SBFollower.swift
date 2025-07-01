//
//  SBFollower.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

struct SBFollower : SupabaseUploadable {
    static var tableName: String {
        return Constants.FOLLOWERS_TABLE
    }
    
    var id: UUID
    var follower:UUID
    var following:UUID
    
    
}
