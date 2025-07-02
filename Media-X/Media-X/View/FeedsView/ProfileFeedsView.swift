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

    let posts:[SBFetchedPost]
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
                        ForEach(posts,id:\.postData.id) { post in
                            PostCellView(post: post){
                                
                            }bookmarkAction: {
                                
                            }commentAction: {
                                
                            }
                                .id(post.postData.id)
                                
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
    }
}
