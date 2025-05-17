//
//  Extension+Data.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation
extension Data {
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

