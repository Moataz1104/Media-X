//
//  AddPostGridView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import SwiftUI

struct AddPostGridView: View {
    var images: [ImageModel]
    @EnvironmentObject var viewModel : AddPostViewModel

    
    private var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing: CGFloat = 4
        let totalColumns: CGFloat = 4
        return (screenWidth - totalSpacing) / totalColumns
    }
    
    var body: some View {
        
        VStack {
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: 1), count: 4), spacing: 1) {
                ForEach(images) { imageModel in
                    PhotoLibraryImageView(imageId: imageModel.id , size: itemWidth)
                        .environmentObject(viewModel)
                        .id(imageModel.id)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
