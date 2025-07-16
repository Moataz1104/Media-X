//
//  SearchManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import Foundation

protocol SearchManagerProtocol {
    func removeRecentModel(currentUserId:UUID, searchedUserId:UUID)async throws -> Result<Void, any Error>
    func uploadRecentSearch(model:SBRecentSearch) async throws -> Result<Void, any Error>
    func fetchSearchResults(userId:String , searchInput:String) async throws -> [SBUserModel]
    func fetchRecent(userId:UUID) async throws-> [SBUserModel]
}

class SearchManager : SupaBaseFunctions , SearchManagerProtocol {
    
    func removeRecentModel(currentUserId:UUID, searchedUserId:UUID)async throws -> Result<Void, any Error> {
        try await deleteModel(
            column1Name: "user_id",
            column1Value: currentUserId,
            column2Name: "searched_user",
            column2Value: searchedUserId,
            tableName: Constants.RECENT_SEARCHS_TABLE
        )
    }
    
    func fetchSearchResults(userId:String , searchInput:String) async throws -> [SBUserModel]{
        try await userSearch(userId: userId, searchInput: searchInput)
    }
    
    func uploadRecentSearch(model:SBRecentSearch) async throws -> Result<Void, any Error>{
        try await uploadModel(model)
    }
    
    func fetchRecent(userId:UUID) async throws-> [SBUserModel] {
        try await getRecentSearches(userId: userId)
    }
    
}
