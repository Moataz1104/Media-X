//
//  PostCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI
import Kingfisher

struct PostCellView:View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @State private var imageIndex:Int = 0
    let post:SBFetchedPost
    let loveAction:()->Void
    let bookmarkAction:()->Void
    let commentAction:()->Void
    
    var body: some View {
        VStack {
            VStack(alignment:.leading) {
                HStack {
                    if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(post.userImage)") {
                        ImageBorderView(imageUrl: url)
                            .frame(width: 80)
                    }
                    VStack(alignment:.leading) {
                        Text(post.userName)
                            .customFont(.medium, size: 15)
                        
                        Text(HelperFunctions.formatTimeString(from: post.postData.dateString))
                            .customFont(.regular, size: 12)
                            .foregroundStyle(.gray)
                    }
                }
                .onTapGesture {
                    navigationStateManager.pushToStage(stage: .profileView(id: post.postData.userId.uuidString))
                }
                
                TabView(selection: $imageIndex) {
                    ForEach(0..<post.imageUrls.count,id:\.self) { i in
                        if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(post.imageUrls[i])"){
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .tag(i)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode:post.imageUrls.count > 1 ? .always: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .scrollDismissesKeyboard(.immediately)
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                    
             
                
                HStack(spacing:10) {
                    PostInteractionButton(icon:post.emojiId == nil ? "heart" : "heart.fill", count: "\(post.lovesCount)", color:post.emojiId == nil ? .black:.red) {
                        loveAction()
                    }
                    
                    PostInteractionButton(icon: "message", count: "\(post.commentsCount)", color: .black) {
                        commentAction()
                    }
                    
//                    PostInteractionButton(icon: "square.and.arrow.up", count: "30") {
//
//                    }
                    
                    Spacer()
                    PostInteractionButton(icon:post.bookmarkId == nil ? "bookmark":"bookmark.fill", count: "", color:post.bookmarkId == nil ? .black:.blue) {
                        bookmarkAction()
                    }
                    
                }
                
                Text(post.postData.caption)
                    .customFont(.regular, size: 18)
                    .foregroundStyle(.black)
            }
            .padding()
            .padding(.vertical,10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
        }
    }
}
