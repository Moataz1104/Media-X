//
//  GlobalUser.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation

class GlobalUser:ObservableObject {
    
    @Published var user:SBUserModel?
    private let manager:UserManagerProtocol
    
    init() {
        manager = UserManager()
    }

    
    func updateUser(userName:String,oldImageId:String?,newImageData:Data?) {
        
        Task {
            do {
                if let newImageData = newImageData , let oldImageId = oldImageId {
                let isDeleted = try await deleteImage(imageId: oldImageId)
                
                    if isDeleted {
                        let id = try await uploadUserImage(imageData: newImageData)
                        
                        if let id = id {
                            try await updateUserModel(userName: userName, imageId: id)
                            await MainActor.run {
                                self.user?.imageId = id
                                self.user?.name = userName
                                
                            }
                        }
                    }
                }else{
                    try await updateUserModel(userName: userName, imageId: self.user?.imageId ?? "")
                    await MainActor.run {
                        self.user?.name = userName
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func updateUserModel(userName:String,imageId:String)async throws {
        guard let userId = manager.getUserId() else { return }
        let userModel = SBUserModel(
            id: userId,
            name: userName,
            imageId: imageId
        )
        let result = try await manager.updateUser(model: userModel)
        
        switch result {
        case .success(_):
            print("updateUser success")
            await MainActor.run {
                self.user?.name = userName
                self.user?.imageId = imageId
            }
        case .failure(let failure):
            throw(failure)
        }
    }
    
    private func deleteImage(imageId:String) async throws -> Bool{
         try await manager.deleteUserImage(fileName: imageId, filePath: "public")
    }
    
    private func uploadUserImage(imageData:Data)async throws -> String? {
        
        let result = try await manager.uploadUserImage(imageData: imageData, filePath:"\(UUID().uuidString).png" )
        switch result {
        case .success(let id):
            return id
        case .failure(let failure):
            throw (failure)
        }
    }

}
