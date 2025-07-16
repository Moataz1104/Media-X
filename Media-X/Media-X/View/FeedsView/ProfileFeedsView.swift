//
//  ProfileFeedsView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI

struct ProfileFeedsView:View {
    @Binding var scrollId:UUID?
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0

    @Binding var posts:[SBFetchedPost]
    @StateObject private var viewModel = InterActionsViewModel()
    @State private var ontapPostId:UUID?
    @State private var ontapUserId:UUID?
    @State private var showComments: Bool = false
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        scrollId = nil
                    }
                }label: {
                    Image(systemName: "xmark")
                        .foregroundColor(._3_B_9678)
                }
                Spacer()
            }
            .padding()
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing:15) {
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
                                ontapUserId = posts[index].postData.userId
                                showComments = true
                            }
                            .id(posts[index].postData.id)
                                
                        }
                    }
                    .padding()
                }
                .onAppear {
                    if let scrollId = scrollId {
                        proxy.scrollTo(scrollId, anchor: .center)
                    }
                }
            }
            .offset(x: offset.width)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.width
                        offset.width = translation
                        opacity = 1.0 - min(abs(translation) / Double(200), 0.9)
                    }
                    .onEnded { value in
                        if abs(value.translation.width) > 100 {
                            self.scrollId = nil
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                                opacity = 1.0
                            }
                        }
                    }
            )
        }
        .background(.F_6_F_8_FA)
        .opacity(opacity)
        .sheet(isPresented: $showComments, onDismiss: {
            ontapPostId = nil
            ontapUserId = nil
        }) {
            if let id = ontapPostId ,let ontapUserId = ontapUserId{
                CommentsSheet(postId: id, userId: ontapUserId)
            } else {
                EmptyView()
            }
        }

    }
}
