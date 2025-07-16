//
//  SBNotification.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import Foundation

struct SBNotification :SupabaseUploadable {
    static var tableName: String {
        return Constants.NOTIFICATION_TABLE
    }
    
    
    
    var id : UUID
    var to:UUID
    var from:UUID
    var postId:UUID?
    var action:String
    var dateString :String? = nil
    var watched:Bool = false
    var imageId:String? = nil
    var username:String? = nil
    enum CodingKeys : String, CodingKey {
        case id
        case to
        case from
        case postId = "post_id"
        case action
        case dateString = "date_string"
        case watched
        case imageId = "image_id"
        case username
    }
}

