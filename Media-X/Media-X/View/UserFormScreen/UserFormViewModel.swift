//
//  UserFormViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import Combine

class UserFormViewModel: ObservableObject {
    
    private let manager:UserManagerProtocol
    
    @Published var username = ""
    @Published var imageData: Data? = nil
    @Published var isLoading = false
    
    var userSubject = PassthroughSubject<SBUserModel?, Never>()
    init() {
        manager = UserManager()
    }
    
    
    func uploadData() {
        isLoading = true
        Task {
            do {
                let imageId = try await uploadUserImage()
                if let imageId = imageId {
                    try await uploadUser(imageId: imageId)
                }
            }catch {
                print(error.localizedDescription)
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func uploadUserImage()async throws -> String? {
        guard let imageData = imageData else{return nil}
        
        let result = try await manager.uploadUserImage(imageData: imageData, filePath:"\(UUID().uuidString).png" )
        switch result {
        case .success(let id):
            return id
        case .failure(let failure):
            
            throw (failure)
        }
    }
    
    private func uploadUser(imageId:String) async throws{
        guard let userId = manager.getUserId() else{return}
        let model = SBUserModel(
            id: userId,
            name: self.username,
            imageId: imageId
        )
        
        
        
        let result = try await manager.uploadUser(model: model)
        switch result {
        case .success(_):
            print("uploadUser success")
            await MainActor.run {
                userSubject.send(model)
            }
        case .failure(let failure):
            throw (failure)
        }
        
    }
    
    
 
    func isButtonDisabled() -> Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        imageData == nil
    }
}

