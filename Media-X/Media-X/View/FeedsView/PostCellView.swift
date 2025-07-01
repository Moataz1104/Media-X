//
//  PostCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI

import Kingfisher
struct PostCellView:View {
    @State private var imageIndex:Int = 0
    let post:SBFetchedPost
    var body: some View {
        VStack {
            VStack(alignment:.leading) {
                HStack {
                    ImageBorderView()
                        .frame(width: 55)
                    VStack(alignment:.leading) {
                        Text(post.userName)
                            .customFont(.medium, size: 15)
                        
                        Text(HelperFunctions.formatTimeString(from: post.postData.dateString))
                            .customFont(.regular, size: 12)
                            .foregroundStyle(.gray)
                    }
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
                    
             
                
                HStack(spacing:20) {
                    PostInteractionButton(icon: "heart", count: "300") {
                        
                    }
                    
                    PostInteractionButton(icon: "bubble", count: "300") {
                        
                    }
                    
//                    PostInteractionButton(icon: "square.and.arrow.up", count: "30") {
//
//                    }
                    
                    Spacer()
                    PostInteractionButton(icon: "bookmark", count: "") {
                        
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
