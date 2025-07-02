//
//  CommentCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import SwiftUI
import Kingfisher
struct CommentCellView:View {
    let model:SBFetchedComment
    let replyId:UUID?
    let replyAction:()->()
    let likeAction:()->()
    var body: some View {
        HStack(alignment:.top) {
            VStack(alignment:.leading) {
                
                HStack {
                    if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(model.imageId)") {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40,height: 40)
                            .clipShape(Circle())
                    }
                    
                    
                    Text(model.userName)
                        .customFont(.bold, size: 18)
                        .foregroundStyle(.black)
                    
                    Text(HelperFunctions.formatTimeString(from: model.dateString))
                        .customFont(.regular, size: 16)
                        .foregroundStyle(.gray)
                }
                
                Text(model.comment)
                    .lineSpacing(5)
                    .customFont(.regular, size: 20)
                    .foregroundStyle(.black)
                
                
                Button {
                    replyAction()
                }label: {
                    HStack {
                        Image(systemName: "arrow.turn.up.right")
                            .customFont(.bold, size: 20)
                            .foregroundStyle(replyId == model.id ? .blue : .gray)
                        
                        Text("Reply")
                            .customFont(.bold, size: 16)
                            .foregroundStyle(replyId == model.id ? .blue : .gray)
                    }
                }
                
            }
            Spacer()
            VStack {
                
                Button {
                    likeAction()
                }label: {
                    Image(systemName:model.likeId == nil ? "heart":"heart.fill")
                        .customFont(.regular, size: 25)
                        .foregroundStyle(model.likeId == nil ? .gray : .red)
                        .frame(width: 24)
                }
                
                Text("\(model.likesCount)")
                    .customFont(.bold, size: 16)
                    .foregroundStyle(model.likeId == nil ? .gray : .red)
            }
        }
        
    }
    
}

