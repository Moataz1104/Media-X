//
//  HomeView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    let postId:UUID?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            BackGroundColorView()
            
            VStack(alignment:.leading,spacing:0) {
                HStack {
                    
                    Button {
                        viewModel.fetchedPost.removeAll()
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    Text("Media X")
                }
                .customFont(.bold, size: 30)
                .foregroundStyle(._3_B_9678)
                .padding([.horizontal, .top])
                
                if let postId = postId {
                    
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
                                ForEach(0..<20){_ in
                                    StoryCellView()
                                }
                                
                            }
                            .padding()
                        }
                        
                        FeedsView(posts: $viewModel.posts) {
                            viewModel.fetchPosts()
                        }
                        .padding()
                        
                    }
                    .refreshable {
                        viewModel.reFreshPosts()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
