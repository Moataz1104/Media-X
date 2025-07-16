//
//  NotificationManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import Foundation

protocol NotificationManagerProtocol {
    func updateNotification(model:SBNotification)async throws -> Result<SBNotification?, any Error>
    func fetchNotifications(userId:String)async throws -> [SBNotification]
    func getUserId() -> UUID?
}

protocol PostNotificationManager : ServerTimeFetchable {
    func uploadNotification(model:SBNotification) async throws -> Result<Void, any Error>
    func getUserId() -> UUID?
}

class NotificationManager : NotificationManagerProtocol , SupaBaseFunctions , PostNotificationManager {
    
    func uploadNotification(model:SBNotification) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    func fetchNotifications(userId:String)async throws -> [SBNotification] {
        try await getNotifications(userId: userId)
    }
    
    func updateNotification(model:SBNotification)async throws -> Result<SBNotification?, any Error> {
        try await updateModel(model, id: model.id)
    }
    
    func getUserId() -> UUID? {
        getUserUID()
    }
    
}


class PostNotification {
    
    private let manager : PostNotificationManager
    static let shared = PostNotification()
    
    private init() {
        manager = NotificationManager()
    }
    
    
    func uploadNotification(toUserId : UUID,action:NotificationAction,postId:UUID? = nil) {
        guard let userId = manager.getUserId(), userId != toUserId else{return}
        Task {
            do {
                let serverTime = try await manager.fetchServerTime()
                let model = SBNotification(
                    id: UUID(),
                    to: toUserId,
                    from: userId,
                    postId:postId,
                    action: action.rawValue,
                    dateString: serverTime
                )
                
                let result = try await manager.uploadNotification(model: model)
                
                switch result {
                case .success(_):
                    print("uploadNotification success")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
