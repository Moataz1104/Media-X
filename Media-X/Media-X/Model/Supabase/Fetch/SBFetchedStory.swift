//
//  SBFetchedStory.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/07/2025.
//

import Foundation



struct SBStoryDetails: Codable {
    let story: SBStory
    let storyImages: [SBStoryImage]
    let user: SBUserModel
    enum CodingKeys: String, CodingKey {
        case story
        case storyImages = "story_images"
        case user
    }
}

