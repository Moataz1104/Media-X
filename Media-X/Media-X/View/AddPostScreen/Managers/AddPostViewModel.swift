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
    @Published var selectedImageIds : [String] = []
    @Published var imagesData: [Data] = []
    @Published var showError: Bool = false
    init(galleryManager: GalleryManager = GalleryManager()) {
        self.galleryManager = galleryManager
        fetchAllPhotos()
    }
    
    func handleOnTapImage(_ image: UIImage,id:String) {
        guard selectedImageIds.count < 6 else{
            showError = true
            return
        }
        if let index = selectedImageIds.firstIndex(of: id) {
            selectedImageIds.remove(at: index)
            imagesData.remove(at: index)
        }else {
            selectedImageIds.append(id)
            getImageDate(image: image)
        }
    }
    
    func handleRemoveImageData(data:Data) {
        if let index = imagesData.firstIndex(of: data) {
            selectedImageIds.remove(at: index)
            imagesData.remove(at: index)
        }
    }
    
    private func getImageDate(image:UIImage) {
        guard let data = galleryManager.imageToData(image,compressionQuality: 1) else{return}
        imagesData.append(data)
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
