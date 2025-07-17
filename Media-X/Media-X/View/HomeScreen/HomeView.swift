//
//  HomeView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var storyVM : StoryViewModel
    let postId:UUID?
    @Environment(\.dismiss) var dismiss
    @State private var showAddStorySheet = false
    @EnvironmentObject var globalUser:GlobalUser
    var body: some View {
        ZStack {
            BackGroundColorView()
            
            VStack(alignment:.leading,spacing:0) {
                HStack {
                    if let _ = postId {
                        Button {
                            viewModel.fetchedPost.removeAll()
                            dismiss()
                        }label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                    Text("Media X")
                }
                .customFont(.bold, size: 30)
                .foregroundStyle(._3_B_9678)
                .padding([.horizontal, .top])
                
                if let _ = postId {
                    
                    if let postId = self.postId {
                        if viewModel.fetchedPost.isEmpty {
                            LoadingView(isLoading: .constant(true))
                                .onAppear {
                                    viewModel.fetchOnePost(for: postId)
                                }
                        }else {
                            ScrollView(showsIndicators:false) {
                                FeedsView(posts: $viewModel.fetchedPost) {}
                                .padding()
                            }
                        }
                    }
                    
                }else {
                    ScrollView(showsIndicators:false) {
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:20) {
                                if let user = globalUser.user {
                                    if storyVM.ihaveStory {
                                        menu(user: user)
                                    }else {
                                        StoryCellView(
                                            model: user,
                                            isMyCell: true,
                                            ihaveStory: storyVM.ihaveStory,
                                            loadingId: storyVM.storyLoadingId
                                        )
                                            .onTapGesture {
                                                showAddStorySheet = true
                                            }

                                    }
                                }
                                
                                ForEach(storyVM.userStoires){user in
                                    StoryCellView(
                                        model: user,
                                        ihaveStory: nil,
                                        loadingId: storyVM.storyLoadingId
                                    )
                                    .onTapGesture {
                                        if storyVM.storyLoadingId == nil {
                                            storyVM.getStoryDetails(userId: user.id)
                                        }
                                    }
                                        
                                }
                                
                            }
                            .padding()
                        }
                        .sheet(isPresented: $showAddStorySheet) {
                            AddPostView(showAddPostSheet:$showAddStorySheet, type: .story)
                        }
                        
                        FeedsView(posts: $viewModel.posts) {
                            viewModel.fetchPosts()
                        }
                        .padding()
                        
                    }
                    .refreshable {
                        viewModel.reFreshPosts()
                        storyVM.refresh()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func menu(user:SBUserModel) -> some View {
        Menu {
            Button {
                showAddStorySheet = true
            } label: {
                Text("New Story")
            }
            
            Button {
                storyVM.getStoryDetails(userId: user.id)
            } label: {
                Text("Show Story")
            }

        } label: {
            StoryCellView(model: user,isMyCell: true, ihaveStory: storyVM.ihaveStory, loadingId: storyVM.storyLoadingId)
                .onTapGesture {
                    showAddStorySheet = true
                }
        }
        .menuStyle(.automatic)
        
    }
}
