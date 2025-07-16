//
//  InterActionsViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

class InterActionsViewModel : ObservableObject {
    
    private let manager:PostInteractionsProtocol
    
    @Published var commentInput:String = ""
    
    init() {
        manager = FeedsManager()
    }
    
    
    func handleLove(post:SBFetchedPost, completion: @escaping (SBFetchedPost) -> Void) {
        var tempPost = post
        Task {
            do {
                if let _ = tempPost.emojiId {
                    tempPost.emojiId = nil
                    tempPost.lovesCount -= 1
                    completion(tempPost)
                    try await self.removeLove(postId: tempPost.postData.id)
                    
                }else {
                    let id = UUID()
                    tempPost.emojiId = id
                    tempPost.lovesCount += 1
                    completion(tempPost)
                    try await self.addLove(postId: tempPost.postData.id, emojiId: id)
                    PostNotification.shared.uploadNotification(toUserId: post.postData.userId, action: .like,postId: post.postData.id)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func handleBookmark(post:SBFetchedPost, completion: @escaping (SBFetchedPost) -> Void) {
        var tempPost = post
        Task {
            do {
                if let _ = tempPost.bookmarkId {
                    tempPost.bookmarkId = nil
                    completion(tempPost)
                    try await self.removeBookmark(postId: tempPost.postData.id)
                    
                }else {
                    let id = UUID()
                    tempPost.bookmarkId = id
                    completion(tempPost)
                    try await self.addBookmark(postId: tempPost.postData.id, bookmarkId: id)
                    PostNotification.shared.uploadNotification(toUserId: post.postData.userId, action: .bookmark,postId: post.postData.id)

                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}

extension InterActionsViewModel {
    private func addLove(postId:UUID,emojiId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        
        let model = SBEmoji(id: emojiId, postId: postId, userId: userId)
        let result = try await manager.addLove(model: model)
        switch result {
        case .success(_):
            print("addLove success")
        case .failure(let failure):
            throw failure
        }
    }
    
    private func addBookmark(postId:UUID,bookmarkId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        let date = try await manager.fetchServerTime()
        let model = SBBookmark(id: bookmarkId, postId: postId, userId: userId, createdAt: date)
        let result = try await manager.addBookmark(model: model)
        switch result {
        case .success(_):
            print("addBookmark success")
        case .failure(let failure):
            throw failure
        }
    }
    
    
    
    
    
    private func removeLove(postId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        
        let result = try await manager.removeLove(userId: userId, postId: postId)
        
        switch result {
        case .success(_):
            print("removeLove success")
        case .failure(let failure):
            throw failure
        }
        
    }
    
    private func removeBookmark(postId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        
        let result = try await manager.removeBookmark(userId: userId, postId: postId)
        
        switch result {
        case .success(_):
            print("removeBookmark success")
        case .failure(let failure):
            throw failure
        }
        
    }

}
