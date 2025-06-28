//
//  StoryCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct StoryCellView:View {
    var body: some View {
        VStack {
            ImageBorderView()
                .frame(width: 80)
            Text("Moataz")
                .customFont(.medium, size: 10)
                .foregroundStyle(.black)
                .frame(width: 50)
                .lineLimit(1)
        }
    }
}
