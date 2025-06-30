//
//  GalleryManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import Foundation
import Photos
import UIKit

class GalleryManager {
    private var allPhotosArray : PHFetchResult<PHAsset>!
    
    func fetchAllPhotos(completion:@escaping (ImageModel) -> ()) {
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                self.allPhotosArray = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                self.allPhotosArray.enumerateObjects { asset, index, stop in
                    completion(.init(id: asset.localIdentifier))
                }
            }
        }
    }
    
    func fetchImage(by id: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Photo library access denied")
                completion(nil)
                return
            }
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
            guard let asset = fetchResult.firstObject else {
                print("No asset found with the provided ID")
                completion(nil)
                return
            }
            
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    func imageToData(_ image: UIImage, compressionQuality: CGFloat = 0.8) ->Data?{
        image.jpegData(compressionQuality: compressionQuality)
    }
}
