//
//  AuthService.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation
import UIKit

protocol AuthServiceProtocol {
    func logInUser(email: String, password: String) async -> Result<String, Error>
    func registerUser(userName: String, email: String, password: String, images: [UIImage]) async -> Result<Void, Error>
}

final class AuthService : AuthServiceProtocol{
    func logInUser(email: String, password: String) async -> Result<String,Error> {
        let body = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: Constants.logInURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingErrors.unknownError)
            }
            
            // Handle 500 status code first
            if httpResponse.statusCode == 500 {
                let decodedMessage = try JSONDecoder().decode(responseErrorsMessage.self, from: data)
                let error = NSError(domain: "", code: 500,
                                  userInfo: [NSLocalizedDescriptionKey: decodedMessage.message])
                
                return .failure(error)
            }
            
            // Check for other error status codes
            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(NetworkingErrors.serverError(httpResponse.statusCode))
            }
            
            // Successful response
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return .success(tokenResponse.token)
            
        } catch let error as NetworkingErrors {
            return .failure(error)
        } catch let decodingError as DecodingError {
            return .failure(NetworkingErrors.decodingError(decodingError))
        } catch {
            return .failure(error)
        }
    }
    
    
    func registerUser(
        userName: String,
        email: String,
        password: String,
        images: [UIImage] = [UIImage(named: "profileIcon")!]
    ) async -> Result<Void , Error>{
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: Constants.registerURL)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonData: [String: Any] = [
            "fullName": userName,
            "email": email,
            "password": password
        ]
        
        do {
            // Create multipart form data
            let body = MultiPartFile.registerMultipartFormDataBody(boundary, json: jsonData, images: images)
            request.httpBody = body
            
            // Perform network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Handle response
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingErrors.unknownError)
            }
            
            // Handle 500 status code
            if httpResponse.statusCode == 500 {
                let decodedMessage = try JSONDecoder().decode(responseErrorsMessage.self, from: data)
                let error = NSError(
                    domain: "",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: decodedMessage.message]
                )
                return .failure(error)
            }
            
            // Check for other error status codes
            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(NetworkingErrors.serverError(httpResponse.statusCode))
            }
            
            // Success case
            return .success(())
            
        } catch let error as NetworkingErrors {
            return .failure(error)
        } catch let decodingError as DecodingError {
            return .failure(NetworkingErrors.decodingError(decodingError))
        } catch {
            return .failure(error)
        }
    }
}
