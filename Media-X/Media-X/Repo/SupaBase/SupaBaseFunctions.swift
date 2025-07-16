//
//  SupaBaseFunctions.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import Supabase


protocol SupaBaseFunctions {
    func getSessionClient() -> SupabaseClient
    func getUserUID() -> UUID?
    func signUpWithEmail(email:String, password:String) async throws
    func signInWithEmail(email:String, password:String) async throws
    func signInWithToken(provider:OpenIDConnectCredentials.Provider,idToken:String,nonce:String) async throws
    func signOut() async throws
    func fetchModelById<T: SupabaseUploadable & Decodable>(id: UUID,culomnIdName:String) async throws -> Result<[T], Error>
    func uploadModels<T: SupabaseUploadable>(_ models: [T]) async throws -> Result<Void, Error>
    func deleteModels(id: [Any], columnName: String, tableName: String) async throws -> Result<Void, Error>
    func uploadFileToStorage(bucket: String, filePath: String, fileData: Data, contentType: String) async throws -> Result<String, Error>
    func fetchModelByTwoFilters<T: SupabaseUploadable & Decodable>(
        filter1: PostgrestFilterValue,
        filter2: PostgrestFilterValue,
        columnName1: String,
        columnName2: String
    ) async throws -> Result<[T], Error>
    
    
    
    func deleteStorageItem(
        fileName: String,
        bucketName: String,
        folderPath: String
    ) async throws -> Bool
    
    func getUserEmail() -> String?
    
    func updateModel<T: SupabaseUploadable>(_ model: T,id:Any,columnName:String) async throws -> Result<T?, Error>
    func fetchServerTime() async throws -> String
    
    func fetchRowCount(
        tableName: String,
        columnName: String,
        filterValue: PostgrestFilterValue
    ) async throws -> Result<Int, Error>
    
    
    func getProfilePosts(userId:String,currentUserId:String) async throws -> [SBFetchedPost]
    func getMyBookmarks(userId:String) async throws -> [SBFetchedPost]
    func deleteModel(
        column1Name: String,
        column1Value: Any,
        column2Name: String,
        column2Value: Any,
        tableName: String
    ) async throws -> Result<Void, Error>
    
    func getPostsPagenated(userId:String,pageNumber:String) async throws -> [SBFetchedPost]
    func getUserFollowers(userId: UUID,my_id:UUID) async throws -> [SBUserModel]
    func getUserFollowings(userId: UUID,my_id:UUID) async throws -> [SBUserModel]
    func getNotifications(userId:String) async throws -> [SBNotification]
    func getOnePostData(userId:UUID , postId:UUID) async throws -> [SBFetchedPost]
}

extension SupaBaseFunctions {
    
    func getSessionClient() -> SupabaseClient {
        SupabaseClient(supabaseURL: URL(string: Constants.SUPABASE_PROJECT_URL_STRING)!, supabaseKey: Constants.SUPABASE_KEY)
        
    }
    
    func signUpWithEmail(email:String, password:String) async throws{
        try await getSessionClient()
            .auth
            .signUp(
                email: email,
                password: password
            )
    }
    func signInWithEmail(email:String, password:String) async throws{
        try await getSessionClient()
            .auth
            .signIn(
                email: email,
                password: password
            )
    }
    
    func getUserUID() -> UUID? {
        getSessionClient().auth.currentUser?.id
    }
    func fetchRowCount(
        tableName: String,
        columnName: String,
        filterValue: PostgrestFilterValue
    ) async throws -> Result<Int, Error> {
        
        let response = try await getSessionClient()
            .from(tableName)
            .select("*", head: true, count: .exact)
            .eq(columnName, value: filterValue)
            .execute()
        
        if (200...299).contains(response.status), let count = response.count {
            return .success(count)
        } else {
            return .failure(NSError(
                domain: "SupabaseError",
                code: Int(response.status),
                userInfo: [NSLocalizedDescriptionKey: "Failed to fetch row count"]
            ))
        }
    }
    
    func signInWithToken(provider:OpenIDConnectCredentials.Provider,idToken:String,nonce:String) async throws {
        try await getSessionClient().auth.signInWithIdToken(credentials: .init(provider: provider, idToken: idToken, nonce: nonce))
    }
    
    func signOut() async throws {
        try await getSessionClient().auth.signOut()
        
    }
    
    
    func uploadModel<T: SupabaseUploadable>(_ model: T) async throws -> Result<Void, Error> {
        let response = try await getSessionClient()
            .from(T.tableName)
            .insert(model)
            .execute()
        
        if (200...299).contains(response.status) {
            return .success(())
        } else {
            return .failure(NSError())
        }
    }
    func uploadModels<T: SupabaseUploadable>(_ models: [T]) async throws -> Result<Void, Error> {
        let response = try await getSessionClient()
            .from(T.tableName)
            .insert(models)
            .execute()
        
        if (200...299).contains(response.status) {
            return .success(())
        } else {
            return .failure(NSError(domain: "SupabaseError", code: Int(response.status), userInfo: [NSLocalizedDescriptionKey: "Failed to upload data"]))
        }
    }
    
    func fetchModelById<T: SupabaseUploadable & Decodable>(id: UUID,culomnIdName:String) async throws -> Result<[T], Error> {
        
            let response = try await getSessionClient()
                .from(T.tableName)
                .select("*")
                .eq(culomnIdName,value: id)
                .execute()

            if (200...299).contains(response.status) {
                
                let decodedData = try JSONDecoder().decode([T].self, from: response.data)
                
                return .success(decodedData)
                
            } else {
                return .failure(NSError(domain: "SupabaseError", code: Int(response.status), userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"]))
            }
    }
    
    func deleteModels(id: [Any], columnName: String = "id", tableName: String) async throws -> Result<Void, Error> {
        let filterValues = id.compactMap { $0 as? PostgrestFilterValue }
        print(filterValues)
        let response = try await getSessionClient()
            .from(tableName)
            .delete()
            .in(columnName, values: filterValues)
            .select("*")
            .execute()
        
        if (200...299).contains(response.status) {
            print("contains(response.status")
            return .success(())
        } else {
            return .failure(NSError(
                domain: "SupabaseError",
                code: Int(response.status),
                userInfo: [NSLocalizedDescriptionKey: "Failed to delete data"]
            ))
        }
    }
    func deleteModel(
        column1Name: String,
        column1Value: Any,
        column2Name: String,
        column2Value: Any,
        tableName: String
    ) async throws -> Result<Void, Error> {
        // Convert to filter values
        guard let col1Filter = column1Value as? PostgrestFilterValue,
              let col2Filter = column2Value as? PostgrestFilterValue else {
            return .failure(NSError(
                domain: "SupabaseError",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Invalid filter values"]
            ))
        }
        
        let response = try await getSessionClient()
            .from(tableName)
            .delete()
            .eq(column1Name, value: col1Filter)
            .eq(column2Name, value: col2Filter)
            .select("*")
            .execute()
        
        // Handle response
        if (200...299).contains(response.status) {
            return .success(())
        } else {
            return .failure(NSError(
                domain: "SupabaseError",
                code: Int(response.status),
                userInfo: [NSLocalizedDescriptionKey: "Failed to delete data"]
            ))
        }
    }
    func fetchModelByTwoFilters<T: SupabaseUploadable & Decodable>(
        filter1: PostgrestFilterValue,
        filter2: PostgrestFilterValue,
        columnName1: String,
        columnName2: String
    ) async throws -> Result<[T], Error> {
        
        let response = try await getSessionClient()
            .from(T.tableName)
            .select("*")
            .eq(columnName1, value: filter1)
            .eq(columnName2, value: filter2)
            .execute()
        
        if (200...299).contains(response.status) {
            
            let decodedData = try JSONDecoder().decode([T].self, from: response.data)
            
            return .success(decodedData)
            
        } else {
            return .failure(NSError(domain: "SupabaseError", code: Int(response.status), userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"]))
        }
    }
    
    
    func updateModel<T: SupabaseUploadable>(_ model: T,id:Any,columnName:String = "id") async throws -> Result<T?, Error> {
        let response = try await getSessionClient()
            .from(T.tableName)
            .update(model)
            .eq("id",value: id as! PostgrestFilterValue)
            .execute()
        
        if (200...299).contains(response.status) {
            
            let decodedData = try JSONDecoder().decode([T].self, from: response.data)
            
            return .success(decodedData.first)
            
        } else {
            return .failure(NSError(domain: "SupabaseError", code: Int(response.status), userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data"]))
        }
        
    }
    
    
    
    
    func uploadFileToStorage(bucket: String, filePath: String, fileData: Data, contentType: String = "application/octet-stream") async throws -> Result<String, Error> {
        
        let response = try await getSessionClient()
            .storage
            .from(bucket)
            .upload(filePath, data: fileData, options: FileOptions(contentType: contentType, upsert: true))
        return .success(response.fullPath)
    }
    
    
    
    
    func deleteStorageItem(
        fileName: String,
        bucketName: String,
        folderPath: String = "public"
    ) async throws -> Bool {
        let client = getSessionClient()
        
        let input = String(fileName.split(separator: "/")[1])
        
        let response = try await client
            .storage
            .from(bucketName)
            .remove(paths: [input])
        
        return !response.isEmpty
    }
    
    
    func getUserEmail() -> String? {
        let client = getSessionClient()
        return client.auth.currentUser?.email
    }
    func fetchServerTime() async throws -> String {
        let response = try await getSessionClient()
            .rpc("get_formatted_server_time")
            .select()
            .single()
            .execute()
        
        let timeString = try JSONDecoder().decode(String.self, from: response.data)
        return timeString
    }
    
//    MARK: - supabase functions
    
    func getProfilePosts(userId:String,currentUserId:String) async throws -> [SBFetchedPost] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_profile_posts",
                params: [
                    "user_id_param": userId,
                    "current_user_id" : currentUserId
                ]
            )
            .execute()

        
        
        if (200...299).contains(response.status) {
            if response.data.isEmpty {
                return []
            }
            let data = try JSONDecoder().decode([SBFetchedPost].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }

    }
    
    func getMyBookmarks(userId:String) async throws -> [SBFetchedPost] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_bookmarked_posts",
                params: [
                    "user_id_param": userId
                ]
            )
            .execute()

        
        
        if (200...299).contains(response.status) {
            if response.data.isEmpty {
                return []
            }
            let data = try JSONDecoder().decode([SBFetchedPost].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }

    }
    
    func getPostsPagenated(userId:String,pageNumber:String) async throws -> [SBFetchedPost] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_random_paginated_posts",
                params: [
                    "current_user_id": userId,
                    "page_number" : pageNumber,
                    "page_size" : "10"
                ]
            )
            .execute()
        
//        if let s = String(data: response.data, encoding: .utf8) {
//            print(s)
//        }
        if (200...299).contains(response.status) {
            if response.data.isEmpty {
                return []
            }
            let data = try JSONDecoder().decode([SBFetchedPost].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }

    }
    
    func fetchComments(userId: UUID, postId: UUID) async throws -> [SBFetchedComment] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_post_comments",
                params: [
                    "p_post_id": postId,
                    "p_current_user_id": userId
                ]
            )
            .execute()


        if (200...299).contains(response.status) {
            let data = try JSONDecoder().decode([SBFetchedComment].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }
    }
    
    
    
    func getUserFollowers(userId: UUID,my_id:UUID) async throws -> [SBUserModel] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_user_followers",
                params: [
                    "current_user_id": userId,
                    "my_id" : my_id
                ]
            )
            .execute()


        if (200...299).contains(response.status) {
            let data = try JSONDecoder().decode([SBUserModel].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }
    }
    
    
    func getUserFollowings(userId: UUID,my_id:UUID) async throws -> [SBUserModel] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_user_followings",
                params: [
                    "current_user_id": userId,
                    "my_id" : my_id
                ]
            )
            .execute()


        if (200...299).contains(response.status) {
            let data = try JSONDecoder().decode([SBUserModel].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }
    }
    
    func getNotifications(userId:String) async throws -> [SBNotification] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_user_notifications",
                params: [
                    "p_user_id": userId
                ]
            )
            .execute()


        if (200...299).contains(response.status) {
            if response.data.isEmpty {
                return []
            }
            let data = try JSONDecoder().decode([SBNotification].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }

    }
    
    func getOnePostData(userId:UUID , postId:UUID) async throws -> [SBFetchedPost] {
        let client = getSessionClient()
        
        let response = try await client
            .rpc(
                "get_one_post_data",
                params: [
                    "p_post_id" : postId,
                    "current_user_id": userId
                ]
            )
            .execute()
        
//        if let s = String(data: response.data, encoding: .utf8) {
//            print(s)
//        }
        if (200...299).contains(response.status) {
            if response.data.isEmpty {
                return []
            }
            let data = try JSONDecoder().decode([SBFetchedPost].self, from: response.data)
            return data
        } else {
            let message = String(data: response.data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseError", code: response.status, userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch recommended chapters: \(message)"
            ])
        }

    }
}


