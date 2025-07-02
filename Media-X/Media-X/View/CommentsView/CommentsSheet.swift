//
//  CommentsSheet.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import SwiftUI
import Kingfisher

struct CommentsSheet: View {
    @State var postId:UUID
    @StateObject private var viewModel = CommentViewModel()
    @StateObject private var keyboardObserver = KeyboardObserver()
    @EnvironmentObject var globalUser :GlobalUser
    var body: some View {
        if viewModel.isLoading {
            LoadingView(isLoading: $viewModel.isLoading)
                .onAppear {
                    viewModel.postId = self.postId
                    viewModel.fetchComments()
                }
        } else {
            VStack(spacing:0) {
                VStack{
                    RoundedRectangle(cornerRadius: 300)
                        .frame(width:92,height:5)
                        .foregroundStyle(.gray.opacity(0.3))
                    
                    Text("comments")
                        .customFont(.medium, size: 20)
                        .foregroundStyle(.black)
                    
                    Rectangle()
                        .frame(height: 0.7)
                        .foregroundStyle(.gray.opacity(0.1))
                }
                .padding(.top)
                
                ScrollView(showsIndicators:false) {
                    VStack {
                        
                        ForEach(viewModel.comments) { comment in
                            CommentSectionView(model: comment,replyId: viewModel.parentId){parentId in
                                if let _ = viewModel.parentId {
                                    viewModel.parentId = nil
                                }else {
                                    viewModel.parentId = parentId
                                }
                            }likeAction: { id in
                                viewModel.handleLove(id: id)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom,100)
                }
                
                VStack(spacing:20){
                    
                    
                    HStack {
                        if let user = globalUser.user ,
                           let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(user.imageId)") {
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40,height: 40)
                                .clipShape(Circle())
                        }
                        
                        TextField("Add your comment", text: $viewModel.input)
                        
                        Button {
                            viewModel.addComment(userName: globalUser.user?.name ?? "", imageId: globalUser.user?.imageId ?? "")
                        }label: {
                            Image(systemName: viewModel.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "paperplane":"paperplane.fill")
                                .customFont(.medium, size: 30)
                                .foregroundStyle(viewModel.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : ._3_B_9678)
                        }
                        .disabled(viewModel.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .frame(height:80)
                .background(.F_6_F_8_FA)
                
            }
            .dismissKeyboardOnTap()
        }
    }
}


struct CommentSectionView:View {
    let model : CommentCellModel
    let replyId:UUID?
    let replyAction:(UUID?)->()
    let likeAction: (UUID) ->()
    var body: some View {
        VStack(spacing:40) {
            CommentCellView(model: model.comment, replyId: replyId){
                replyAction(model.comment.id)
            } likeAction: {
                likeAction(model.comment.id)
            }
            VStack(spacing:40) {
                ForEach(model.children,id:\.id) { comment in
                    CommentCellView(model: comment, replyId: replyId) {
                        replyAction(comment.parentId)
                    }likeAction: {
                        likeAction(comment.id)
                    }
                }
            }
            .padding(.leading,20)
        }

    }
}




