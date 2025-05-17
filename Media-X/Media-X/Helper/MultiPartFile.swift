//
//  MultiPartFile.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//



import Foundation
import UIKit

struct MultiPartFile {
    
    static func registerMultipartFormDataBody(_ boundary: String,json:[String:Any], images: [UIImage]) -> Data {
        
        
        let lineBreak = "\r\n"
        var body = Data()

        

        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"registerRequestDto\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(jsonData)
        body.append(lineBreak)

        
        for image in images {
            if let uuid = UUID().uuidString.components(separatedBy: "-").first {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"imageFile\"; filename=\"\(uuid).jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(image.jpegData(compressionQuality: 0.99)!)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")
        return body
    }

    static func postMultipartFormDataBody(_ boundary: String,imageData:Data,content:String) -> Data{
        
        let lineBreak = "\r\n"
        var body = Data()

        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"content\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(content)
        body.append(lineBreak)

        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"postImage\"; filename=\"\(uuid).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }

        
        body.append("--\(boundary)--\(lineBreak)")
        return body

    }

    
    static func updateUserMultipartFormDataBody(_ boundary: String,json:[String:Any], imageData:Data) -> Data {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        let lineBreak = "\r\n"
        var body = Data()

        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"userProfileUpdateDto\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(jsonData)
        body.append(lineBreak)

        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"imageFile\"; filename=\"\(uuid).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }

        
        body.append("--\(boundary)--\(lineBreak)")
        return body

    }
    
    static func addStoryMultipartFormDataBody(boundary: String, imageData:Data)-> Data{
        let lineBreak = "\r\n"
        var body = Data()

        body.append("--\(boundary + lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(lineBreak)

        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"imageFile\"; filename=\"\(uuid).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }

        
        body.append("--\(boundary)--\(lineBreak)")
        return body

    }

}
