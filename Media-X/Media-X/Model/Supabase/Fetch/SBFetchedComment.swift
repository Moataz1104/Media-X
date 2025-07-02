//
//  SBFetchedComment.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//



import Foundation

struct SBFetchedComment : Codable {
    var id :UUID
    var userId :UUID
    var parentId: UUID?
    var dateString:String
    var likeId :UUID?
    var userName :String
    var imageId :String
    var comment:String
    var likesCount:Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case parentId = "parent_id"
        case dateString = "date_string"
        case likeId = "like_id"
        case userName = "user_name"
        case imageId = "image_id"
        case likesCount = "like_count"
        case comment
    }
}
