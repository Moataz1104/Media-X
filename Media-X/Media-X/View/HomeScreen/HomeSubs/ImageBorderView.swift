//
//  ImageBorderView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI
import Kingfisher
struct ImageBorderView:View {
    let imageUrl:URL
    var body: some View {
        KFImage(imageUrl)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 6)
                    .overlay {
                        Circle()
                            .stroke(._3_B_9678, lineWidth: 3)
                    }
            }
    }
}
