//
//  SupabaseUploadable.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation

protocol SupabaseUploadable : Identifiable,Hashable, Codable {
    static var tableName: String { get }
    
}

