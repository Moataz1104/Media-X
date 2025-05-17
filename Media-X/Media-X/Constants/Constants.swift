//
//  Constants.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation

let IS_TESTING = true
struct Constants{
//    https://tumbler.onrender.com/
    static let logInURL =
    URL(string: "https://tumbler.onrender.com/v0/auth/login")!
    static let registerURL =
    URL(string: "https://tumbler.onrender.com/v0/auth/register")!
    static let addPostURL = URL(string: "https://tumbler.onrender.com/v0/posts")!
    static let currentUserURL = URL(string:"https://tumbler.onrender.com/v0/user/profile/current")!
    static let currentUserPostsURL = URL(string:"https://tumbler.onrender.com/v0/posts/current_user-posts")!
    static let updateUserURL = URL(string:"https://tumbler.onrender.com/v0/user/profile")!
    static let getStoriesURL = URL(string:"https://tumbler.onrender.com/v0/story/followers")!
    static let getNotificationsURL = URL(string: "https://tumbler.onrender.com/v0/notifications")!
    static let readNotificationForProfileURL = URL(string: "https://tumbler.onrender.com/v0/user/notification-profile")!
    static let readNotificationForPostURL = URL(string: "https://tumbler.onrender.com/v0/posts/notification-post")!
    static let addStoryURL =  URL(string: "https://tumbler.onrender.com/v0/story")!

    static let getOnePostStringUrl =  "https://tumbler.onrender.com/v0/posts/"
    static let addCommentStringUrl = "https://tumbler.onrender.com/v0/comments/post/"
    static let commentsStringUrl = "https://tumbler.onrender.com/v0/comments/"
    static let likeUrlString = "https://tumbler.onrender.com/v0/likes/post/"
    static let otherUserProfileStr = "https://tumbler.onrender.com/v0/user/post/profile/"
    static let otherUserPostsStr = "https://tumbler.onrender.com/v0/posts/user/"
    static let searchUserStr = "https://tumbler.onrender.com/v0/user/search"
    static let allPostsPaginatedStr =  "https://tumbler.onrender.com/v0/posts/paginated-posts?page=0&size="
    static let followUrlString = "https://tumbler.onrender.com/v0/followers/follow/"
    static let deleteUserFromRecentStr = "https://tumbler.onrender.com/v0/user/recent-search/"
    static let getUserFromSearch = "https://tumbler.onrender.com/v0/user/search/profile/"
    static let getStoryDetailsStr = "https://tumbler.onrender.com/v0/story/user/"
    static let getStoryViewsStr = "https://tumbler.onrender.com/v0/story/views/"
    static let getFollowingUsersStr = "https://tumbler.onrender.com/v0/followers/following-details/"
    static let getFollowersUsersStr = "https://tumbler.onrender.com/v0/followers/followers-details/"

    
    
    static let TOKEN = "token"
    static let MOCK_EMAIL = "moataz.mohamed.id2@gmail.com"
    static let MOCK_PASSWORD = "MmMm@1234"
    static let LOG_IN_TIME_STAMP = "loginTimestamp"
    static let ERROR_MESSAGE = "The request timed out."
}
