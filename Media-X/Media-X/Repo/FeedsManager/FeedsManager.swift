//
//  FeedsManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation



protocol PostsFetchingProtocol:UserIDFetchable{
    func fetchPostsPagenated(userId:String,page:String) async throws -> [SBFetchedPost]
}
protocol PostInteractionsProtocol:UserIDFetchable{
    func addLove(model:SBEmoji) async throws -> Result<Void, any Error>
    func addBookmark(model:SBBookmark) async throws -> Result<Void, any Error>
    
    func removeLove(userId:UUID,postId:UUID) async throws -> Result<Void, any Error>
    func removeBookmark(userId:UUID,postId:UUID) async throws -> Result<Void, any Error>
    
}

protocol CommentProtocol:UserIDFetchable {
    
    func addComment(model:SBComment) async throws -> Result<Void, any Error>
    func addCommentLove(model:SBCommentLove) async throws -> Result<Void, any Error>
    func removeCommentLove(userId:UUID,commentId:UUID) async throws -> Result<Void, any Error>
    func fetchAllComments( userId:UUID,postId:UUID) async throws -> [SBFetchedComment]
}


class FeedsManager :PostsFetchingProtocol,PostInteractionsProtocol,SupaBaseFunctions ,CommentProtocol{
    
    
    func fetchAllComments( userId:UUID,postId:UUID) async throws -> [SBFetchedComment]{
        try await fetchComments(userId: userId, postId: postId)
    }
    
    func fetchPostsPagenated(userId:String,page:String) async throws -> [SBFetchedPost]{
        try await getPostsPagenated(userId: userId, pageNumber: page)
    }
    
    func addLove(model:SBEmoji) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    func addBookmark(model:SBBookmark) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    func addComment(model:SBComment) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    func addCommentLove(model:SBCommentLove) async throws -> Result<Void, any Error> {
        try await uploadModel(model)
    }
    
    
    func removeLove(userId:UUID,postId:UUID) async throws -> Result<Void, any Error>{
        try await deleteModel(
            column1Name: "user_id",
            column1Value: userId,
            column2Name: "post_id",
            column2Value: postId,
            tableName: Constants.EMOJIS_TABLE
        )
    }
    
    func removeBookmark(userId:UUID,postId:UUID) async throws -> Result<Void, any Error>{
        try await deleteModel(
            column1Name: "user_id",
            column1Value: userId,
            column2Name: "post_id",
            column2Value: postId,
            tableName: Constants.BOOKMAR_TABLE
        )
    }
    
    
    func removeCommentLove(userId:UUID,commentId:UUID) async throws -> Result<Void, any Error>{
        try await deleteModel(
            column1Name: "user_id",
            column1Value: userId,
            column2Name: "comment_id",
            column2Value: commentId,
            tableName: Constants.COMMENTS_LOVE_TABLE
        )
    }
    
}
