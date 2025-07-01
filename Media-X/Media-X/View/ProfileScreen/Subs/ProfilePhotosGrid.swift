//
//  ProfilePhotosGrid.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI
import Kingfisher

struct ProfilePhotosGrid: View {
    let posts :[SBFetchedPost]
    let onTapAction:(UUID)->()
    private let width = UIScreen.main.bounds.width / 3
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 1), count: 3), spacing: 1) {
                ForEach(posts,id:\.postData.id) { post in
                    if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(post.imageUrls.first ?? "")"){
                        KFImage(url)
                            .placeholder {
                                Rectangle()
                                    .foregroundStyle(.gray.opacity(0.5))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: width,height: width)
                            .clipped()
                            .onTapGesture {
                                onTapAction(post.postData.id)
                            }
                    }
                }
            }
            .padding(.top, 2)
            .padding(.bottom, 120)
        }
        .scrollIndicators(.hidden)
    }
}

