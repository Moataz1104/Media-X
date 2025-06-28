//
//  HelperFunctions.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//


import Foundation
import CryptoKit
import UIKit
import SwiftUI


struct HelperFunctions {
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    static func convertStringToDate(_ stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.date(from: stringDate)
    }
    
    
    static func generateAppleClientSecret(keyId: String, teamId: String, clientId: String, privateKeyP8: String) -> String? {
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 60 * 60 * 24 * 180 // 180 days
        
        let header = [
            "alg": "ES256",
            "kid": keyId
        ]
        
        let payload = [
            "iss": teamId,
            "iat": iat,
            "exp": exp,
            "aud": "https://appleid.apple.com",
            "sub": clientId
        ] as [String : Any]
        
        func base64URLEncode(_ data: Data) -> String {
            data.base64EncodedString()
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }
        
        guard let headerData = try? JSONSerialization.data(withJSONObject: header),
              let payloadData = try? JSONSerialization.data(withJSONObject: payload) else {
            return nil
        }
        
        let headerEncoded = base64URLEncode(headerData)
        let payloadEncoded = base64URLEncode(payloadData)
        let signingInput = "\(headerEncoded).\(payloadEncoded)"
        
        // Process the .p8 private key
        let privateKey = parsePrivateKey(from: privateKeyP8)
        
        guard let privateKey = privateKey,
              let signingData = signingInput.data(using: .utf8) else {
            return nil
        }
        
        do {
            let signature = try privateKey.signature(for: signingData)
            let signatureEncoded = base64URLEncode(signature.derRepresentation)
            return "\(signingInput).\(signatureEncoded)"
        } catch {
            return nil
        }
    }

    private static func parsePrivateKey(from pemString: String) -> P256.Signing.PrivateKey? {
        // Clean the PEM string
        let cleanedPem = pemString
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = Data(base64Encoded: cleanedPem) else {
            return nil
        }
        
        do {
            return try P256.Signing.PrivateKey(derRepresentation: data)
        } catch {
            return nil
        }
    }
}
