//
//  UserManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation


protocol UserManagerProtocol:UserIDFetchable , UserUpdateHandler {
    
    func uploadUser(model:SBUserModel) async throws -> Result<Void, any Error>
    func deleteUserImage(fileName:String,filePath: String) async throws -> Bool
    func uploadUserImage(imageData:Data,filePath:String) async throws -> Result<String, any Error>
    
}

protocol UserUpdateHandler {
    func updateUser(model: SBUserModel) async throws -> Result<SBUserModel?, any Error>
}

class UserManager : UserManagerProtocol , SupaBaseFunctions {
    
    func updateUser(model:SBUserModel)async throws -> Result<SBUserModel?, any Error> {
        try await updateModel(model, id: model.id)
    }
    
    func deleteUserImage(fileName:String,filePath: String) async throws -> Bool {
        try await deleteStorageItem(fileName: fileName, bucketName: Constants.USERS_IMAGES_BUCKET, folderPath: filePath)
    }
    
    func uploadUserImage(imageData:Data,filePath:String) async throws -> Result<String, any Error> {
        try await uploadFileToStorage(bucket: Constants.USERS_IMAGES_BUCKET, filePath: filePath, fileData: imageData , contentType: "application/octet-stream")
        
    }
    
    func uploadUser(model:SBUserModel) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    
}
