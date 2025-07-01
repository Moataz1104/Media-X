//
//  UploadPostViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

class UploadPostViewModel : ObservableObject {
    
    private let manager : UploadPostProtocol
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage : String = ""
    @Published var uploadingProgress : Double = 0
    private var totalProgress = 0
    private var singleProgress = 0{
        didSet {
            uploadingProgress = Double(singleProgress) / Double(totalProgress)
        }
    }
    init() {
        manager = PostManager()
    }
    
    
    func uploadPostData(imagesData:[Data],caption:String) {
        guard let userId = manager.getUserId() else{return}
        isLoading = true
        totalProgress = imagesData.count + 1
        let postId = UUID()
        Task {
            do {
                let serverTime = try await manager.getServerTime()
                let model = SBPost(id: postId, userId: userId, caption: caption, dateString: serverTime)
                let postResult = try await manager.uploadPost(model: model)
                
                switch postResult {
                    
                case .success(_):
                    await MainActor.run {
                        self.singleProgress += 1
                    }
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        for i in 0..<imagesData.count {
                            group.addTask {
                                try await self.uploadImage(postId: postId, imageData: imagesData[i],index: i)
                            }
                        }
                        
                        try await group.waitForAll()
                    }
                    
                    
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                
                
            }catch {
                print(error.localizedDescription)
                await MainActor.run {
                    self.isLoading = false
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.uploadingProgress = 0
                self.totalProgress = 0
                self.singleProgress = 0
                self.isLoading = false
            }
            
        }
    }
    
    
    
    private func uploadImage(postId:UUID,imageData:Data,index:Int) async throws {
        
        let imageIdResult = try await manager.uploadImageToStorage(data: imageData, filePath: UUID().uuidString)
        
        switch imageIdResult {
        case .success(let id):
            try await uploadImageModel(postId: postId, imageId: id,index:index)
            await MainActor.run {
                self.singleProgress += 1
            }
        case .failure(let failure):
            throw failure
        }
    }
    
    private func uploadImageModel(postId:UUID, imageId:String,index:Int)async throws {
        
        let model = SBPostImage(id: UUID(), postId: postId, urlString: imageId,imageIndex: index)
        
        let result = try await manager.uploadImageModel(model: model)
        
        switch result {
        case .success(_):
            await MainActor.run {
                self.singleProgress += 1
            }
            print("uploadImageModel success")
        case .failure(let failure):
            throw failure
        }
    }
    
    
}
