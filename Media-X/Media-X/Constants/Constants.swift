//
//  Constants.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation

let IS_TESTING = true
struct Constants{
    
    //MARK: - Supabase
    static let SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJpdmhoZnBwY3J1aGl4eGF0bGZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTExMTQ1MzMsImV4cCI6MjA2NjY5MDUzM30.j0owH8A2Go6RvVvjrkTYkGrrPx_7KtABsDWsVD6NaUE"
    
    static let SUPABASE_PROJECT_URL_STRING = "https://bivhhfppcruhixxatlfh.supabase.co"
    static let SUPABASE_STORAGE_END_POINT = "https://bivhhfppcruhixxatlfh.supabase.co/storage/v1/object/public/"

    //MARK: - Tables
    
    static let USERS_TABLE = "users"
    static let POSTS_TABLE = "posts"
    static let POSTS_IMAGES_TABLE = "posts_images"
    static let STORIES_IMAGES_TABLE = "story_images"
    static let BOOKMAR_TABLE = "bookmarks"
    static let EMOJIS_TABLE = "emojis"
    static let FOLLOWERS_TABLE = "followers"
    static let COMMENTS_TABLE = "comments"
    static let COMMENTS_LOVE_TABLE = "comments_love"
    static let NOTIFICATION_TABLE = "notifications"
    static let RECENT_SEARCHS_TABLE = "recent_searches"
    static let STORIES_TABLE = "stories"
    static let WATCHED_STORIES_TABLE = "watched_stories"
    //MARK: - Buckets
    static let USERS_IMAGES_BUCKET = "users.images"
    static let POSTS_IMAGES_BUCKET = "posts.images"
    static let STORIES_IMAGES_BUCKET = "stories.images"
    
    //MARK: - Keys
    static let TOKEN = "token"
    static let MOCK_EMAIL = "moataz.mohamed.id2@gmail.com"
    static let MOCK_PASSWORD = "MmMm@1234"
    static let LOG_IN_TIME_STAMP = "loginTimestamp"
    static let ERROR_MESSAGE = "The request timed out."
    static let ERROR_COMPLETION = " Please try Again the server is sleeping"
}
