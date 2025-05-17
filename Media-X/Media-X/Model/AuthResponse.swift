//
//  AuthResponse.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation

struct TokenResponse:Codable{
    let token:String
}
struct responseErrorsMessage : Codable {
    let message : String
}
