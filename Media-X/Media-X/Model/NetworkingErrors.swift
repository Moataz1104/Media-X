//
//  NetworkingErrors.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation



enum NetworkingErrors : Error {
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case noData
    case unknownError
    case customError(String)
    
    var localizedDescription:String {
        switch self {
        case .networkError(let error):
            return "\(error.localizedDescription)"
        case .decodingError(let error):
            return "\(error.localizedDescription)"
        case .serverError(let statusCode):
            return "status code: \(statusCode)"
        case .noData:
            return "No data received from the server"
        case .unknownError:
            return "An unknown error occurred"
        case .customError(let message):
            return message

        }
    }
    
    var title:String{
        switch self {
        case .networkError(_):
            return "Network error"
        case .decodingError(_):
            return "Decoding error"
        case .serverError(_):
            return "Server error"
        case .noData:
            return "No data"
        case .unknownError:
            return "An unknown"
        case .customError(_):
            return "Error"
        }
    }
}
