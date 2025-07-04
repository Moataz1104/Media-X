//
//  SBUserModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation

struct SBUserModel :SupabaseUploadable{
    static var tableName: String {
        return Constants.USERS_TABLE
    }
    
    var id:UUID
    var name:String
    var imageId:String
    
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case imageId = "image_id"
    }
}
