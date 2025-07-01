//
//  UserIDFetchable.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation
protocol UserIDFetchable :SupaBaseFunctions{
    func getUserId() -> UUID?
}
extension UserIDFetchable {
    func getUserId() -> UUID? {
        getUserUID()
    }
}
