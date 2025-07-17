//
//  StoryCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct StoryCellView:View {
    let model:SBUserModel
    @State var isMyCell:Bool = false
    let ihaveStory:Bool?
    let loadingId:UUID?
    var body: some View {
        VStack {
            if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(model.imageId)") {
                ImageBorderView(imageUrl: url)
                    .frame(width: 80,height:80)
                    .overlay {
                        if isMyCell {
                            if let ihaveStory = ihaveStory , !ihaveStory{
                                Image(systemName: "plus")
                                    .customFont(.medium, size: 8)
                                    .foregroundStyle(.white)
                                    .padding(5)
                                    .background(._3_B_9678)
                                    .clipShape(.rect(cornerRadius: 4))
                                
                            }
                        }
                    }
                    .overlay {
                        
                        if let loadingId = loadingId, loadingId == model.id {
                            Color
                                .black
                                .opacity(0.5)
                                .clipShape(.circle)
                            ProgressView()
                                .tint(.white)
                        }
                    }
            }
            Text(model.name)
                .customFont(.medium, size: 10)
                .foregroundStyle(.black)
                .frame(width: 50)
                .lineLimit(1)
        }
    }
}
