//
//  AddPostViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//



import Foundation
import Photos
import UIKit
import SwiftUI


@MainActor
final class AddPostViewModel: ObservableObject {
    private let galleryManager: GalleryManager
    
    @Published var imageList: [ImageModel] = []
    @Published var caption = ""
    @Published var selectedImageId : String? = nil
    @Published var imageData: Data?
    
    init(galleryManager: GalleryManager = GalleryManager()) {
        self.galleryManager = galleryManager
        fetchAllPhotos()
    }
    
    func getImageDate(image:UIImage) {
        imageData = galleryManager.imageToData(image,compressionQuality: 1)
    }
    
    func fetchImage(by id: String, targetSize: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            galleryManager.fetchImage(by: id, targetSize: targetSize) { image in
                continuation.resume(returning: image)
            }
        }
    }
    private func fetchAllPhotos() {
        galleryManager.fetchAllPhotos { model in
            if self.imageList.firstIndex(where: {$0.id == model.id}) == nil
            {
                DispatchQueue.main.async{
                    self.imageList.append(.init(id: model.id))
                }
            }
        }
    }
}
