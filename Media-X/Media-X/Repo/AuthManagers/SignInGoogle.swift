//
//  SignInGoogle.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import UIKit
import CryptoKit
import GoogleSignIn


@MainActor
class SignInGoogle {
    
    func startSignInWithGoogleFlow() async throws -> SignInResult {
        try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.signInWithGoogleFlow { result in
                continuation.resume(with: result)
            }
        })
        
    }
    
    func signInWithGoogleFlow(completion: @escaping (Result<SignInResult, Error>) -> Void) {
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(NSError(domain: "SignInGoogle", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not get top view controller"])))
            return
        }
        
        let rawNonce = HelperFunctions.randomNonceString()
        let hashedNonce = HelperFunctions.sha256(rawNonce)
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "SignInGoogle", code: -2, userInfo: [NSLocalizedDescriptionKey: "Could not get ID token"])))
                return
            }
            
            completion(.success(.init(idToken: idToken, nonce: hashedNonce)))
        }
    }
}

