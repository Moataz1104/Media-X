//
//  PhotoLibraryImageView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import Foundation
import SwiftUI
import Photos

struct PhotoLibraryImageView: View {
    let imageId: String
    @State private var loadedImage: UIImage? = nil
    @EnvironmentObject var viewModel : AddPostViewModel
    let size : CGFloat
    var body: some View {
        Group {
            VStack{
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size,height: size)
                        
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: size,height: size)
                        .onAppear {
                            Task {
                                loadedImage = await viewModel.fetchImage(by: imageId, targetSize: CGSize(width: 1000, height: 1000))
                            }
                        }
                }
            }
            .clipped()
            .contentShape(.rect)
            .onTapGesture {
                if let loadedImage = loadedImage {
                    viewModel.handleOnTapImage(loadedImage, id: imageId)
                }
            }
            .overlay {
                if viewModel.selectedImageIds.contains(imageId) {
                    Rectangle()
                        .stroke(._3_B_9678, lineWidth: 3)
                }else {
                    Rectangle()
                        .stroke(.clear, lineWidth: 3)
                }
            }
        }
        
    }
}
