//
//  NotificationActions.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import Foundation

enum NotificationAction :String{
    case like = "like"
    case comment = "comment"
    case share = "share"
    case bookmark = "bookmark"
    case follow = "follow"
    
    
    
    func getNotificationTitle(userName:String) -> String{
        switch self {
        case .like:
            return "\(userName) has liked your post"
        case .comment:
            return "\(userName) has commented on your post"
        case .share:
            return "\(userName) has shared your post"
        case .bookmark:
            return "\(userName) has bookmarked your post"
        case .follow :
            return "\(userName) started following you"
        }
    }
}
