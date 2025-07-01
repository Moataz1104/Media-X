//
//  SBFetchedPost.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

struct SBFetchedPost :Codable{

        
    let postData: SBPost
    let imageUrls: [String]
    let userName, userImage: String
    let bookmarkId: UUID?
    let emojiId:UUID?
    let emoji:String?
    
    enum CodingKeys: String, CodingKey {
        case postData = "post_data"
        case imageUrls = "image_urls"
        case userName = "user_name"
        case userImage = "user_image"
        case bookmarkId = "bookmark_id"
        case emojiId = "emoji_id"
        case emoji
    }
}

