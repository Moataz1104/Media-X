//
//  ImageBorderView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct ImageBorderView:View {
    var body: some View {
        Image(.me)
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
