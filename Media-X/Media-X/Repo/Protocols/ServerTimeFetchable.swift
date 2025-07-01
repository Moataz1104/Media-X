//
//  ServerTimeFetchable.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation

protocol ServerTimeFetchable :SupaBaseFunctions{
    func getServerTime() async throws -> String
}
extension ServerTimeFetchable {
    func getServerTime() async throws -> String {
        try await fetchServerTime()
    }
}
