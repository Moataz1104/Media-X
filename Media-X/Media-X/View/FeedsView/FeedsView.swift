//
//  FeedsView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI

struct FeedsView: View {
    @EnvironmentObject var globalUser:GlobalUser
    @Binding var posts:[SBFetchedPost]
    let getNextPostsAction: () -> ()
    
    @State private var showComments: Bool = false
    @State private var ontapPostId:UUID?
    @StateObject private var viewModel = InterActionsViewModel()
    var body: some View {
        LazyVStack{
            ForEach(0..<posts.count,id:\.self) { index in
                PostCellView(post: posts[index]) {
                    viewModel.handleLove(post: posts[index]) { newModel in
                        DispatchQueue.main.async {
                            posts[index] = newModel
                        }
                    }
                }bookmarkAction: {
                    viewModel.handleBookmark(post:posts[index]) { newModel in
                        DispatchQueue.main.async {
                            posts[index] = newModel
                        }
                    }
                }commentAction: {
                    ontapPostId = posts[index].postData.id
                    showComments = true
                }
                .onAppear {
                    if index >= self.posts.count-3 {
                        self.getNextPostsAction()
                    }
                }
            }
        }
        .sheet(isPresented: $showComments,onDismiss: {self.ontapPostId = nil}) {
            CommentsSheet(
                postId: ontapPostId ?? UUID())
        }
    }
}


