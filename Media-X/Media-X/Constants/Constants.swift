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
    static let SUPABASE_STORAGE_END_POINT = "https://bivhhfppcruhixxatlfh.supabase.co/storage/v1/s3/object/public/"

    
    //MARK: - Tables
    
    static let USERS_TABLE = "users"
    
    
    //MARK: - Buckets
    
    
    
    //MARK: - Keys
    static let TOKEN = "token"
    static let MOCK_EMAIL = "moataz.mohamed.id2@gmail.com"
    static let MOCK_PASSWORD = "MmMm@1234"
    static let LOG_IN_TIME_STAMP = "loginTimestamp"
    static let ERROR_MESSAGE = "The request timed out."
    static let ERROR_COMPLETION = " Please try Again the server is sleeping"
}
