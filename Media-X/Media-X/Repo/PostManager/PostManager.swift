//
//  PostManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import Foundation

protocol UploadPostProtocol:UserIDFetchable, ServerTimeFetchable {
    func uploadPost(model:SBPost) async throws -> Result<Void, any Error>
    func uploadImageToStorage(data:Data,filePath:String,isPost:Bool) async throws -> Result<String, any Error> 
    func uploadImageModel<T: SupabaseUploadable>(model: T) async throws -> Result<Void, any Error>
    func uploadStory(model:SBStory) async throws -> Result<Void, any Error>
}




class PostManager : SupaBaseFunctions {}


//MARK: - Upload
extension PostManager : UploadPostProtocol {
    
    func uploadPost(model:SBPost) async throws -> Result<Void, any Error>{
        try await uploadModel(model)
    }
    
    func uploadImageToStorage(data:Data,filePath:String,isPost:Bool) async throws -> Result<String, any Error> {
        try await uploadFileToStorage(
            bucket: isPost ? Constants.POSTS_IMAGES_BUCKET : Constants.STORIES_IMAGES_BUCKET,
            filePath: filePath,
            fileData: data,
            contentType: "application/octet-stream"
        )
    }
    
    func uploadImageModel<T: SupabaseUploadable>(model: T) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }

    func uploadStory(model:SBStory) async throws -> Result<Void, any Error>{
        try await uploadModel(model)
    }

}
