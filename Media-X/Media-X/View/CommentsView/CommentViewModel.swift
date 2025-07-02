//
//  CommentViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

@MainActor
class CommentViewModel : ObservableObject {
 
    
    var postId:UUID?
    private var fetchedComments : [SBFetchedComment] = []
    @Published var isLoading = true
    @Published var comments : [CommentCellModel] = []
    @Published var input = ""
    @Published var parentId : UUID?
    
    private let manager : CommentProtocol
    
    init() {
        manager = FeedsManager()
    }
    
    func fetchComments() {
        guard let userId = manager.getUserId(),let postId = postId else { return }
        isLoading = true
        Task {
            do {
                let comments = try await manager.fetchComments(userId: userId, postId: postId)
                await MainActor.run {
                    self.fetchedComments = comments
                    self.handleCommentsTree()
                    self.isLoading = false
                }
                
            }catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
            
        }
        
    }
    private func handleCommentsTree() {
    
        let childrenDict = Dictionary(grouping: fetchedComments.filter { $0.parentId != nil }) { $0.parentId! }
        
        let parents = fetchedComments.filter { $0.parentId == nil }
            .sorted { $0.dateString > $1.dateString }
        
        let parentModels = parents.map { parent -> CommentCellModel in
            let children = childrenDict[parent.id]?
                .sorted { $0.dateString < $1.dateString }
                ?? []
            
            return CommentCellModel(comment: parent, children: children)
        }
        
        DispatchQueue.main.async {
            self.comments.removeAll()
            self.comments = parentModels
        }
        
        
    }
    
    
    private func addCommentLove(commentId:UUID,loveId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        let model = SBCommentLove(id: loveId, commentId: commentId, userId: userId)
        let result = try await manager.addCommentLove(model: model)
        switch result {
        case .success(_):
            print("addCommentLove success")
        case .failure(let failure):
            throw failure
        }
    }
    private func removeCommentLove(commentId:UUID) async throws{
        guard let userId = manager.getUserId() else { return }
        
        
        
        let result = try await manager.removeCommentLove(userId: userId, commentId: commentId)
        switch result {
        case .success(_):
            print("removeCommentLove success")
        case .failure(let failure):
            throw failure
        }
        
    }
    
    func handleLove(id:UUID) {
        guard let index = self.fetchedComments.firstIndex(where: {$0.id == id}) else{return}
        Task {
            do {
                if let _ = fetchedComments[index].likeId {
                    fetchedComments[index].likeId = nil
                    fetchedComments[index].likesCount -= 1
                    handleCommentsTree()
                    try await self.removeCommentLove(commentId: id)
                }else {
                    let uuid = UUID()
                    fetchedComments[index].likeId = uuid
                    fetchedComments[index].likesCount += 1
                    handleCommentsTree()
                    try await self.addCommentLove(commentId: id,loveId:uuid)
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }

    
    func addComment(userName:String,imageId:String){
        guard let userId = manager.getUserId(), let postId = postId else { return }
        let tempInput = self.input
        self.input = ""
        Task {
            do {
                let date = try await manager.fetchServerTime()
                let model = SBComment(
                    id: UUID(),
                    parentId:self.parentId,
                    comment: tempInput,
                    userId: userId,
                    postId: postId,
                    dateString: date
                )
                let fetchedModel = SBFetchedComment(
                    id: model.id,
                    userId: userId,
                    parentId:self.parentId,
                    dateString: date,
                    userName: userName,
                    imageId: imageId,
                    comment: model.comment,
                    likesCount: 0
                )
                
                self.fetchedComments.append(fetchedModel)
                self.handleCommentsTree()
                self.parentId = nil
                let result = try await manager.addComment(model: model)
                switch result {
                case .success(_):
                    print("addComment success")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
