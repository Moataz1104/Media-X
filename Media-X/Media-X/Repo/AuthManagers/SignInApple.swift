//
//  SignInApple.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import CryptoKit
import AuthenticationServices


@MainActor
class SignInApple: NSObject {
    
    
    private var currentNonce: String?
    private var completionHandler: ((Result<SignInResult, Error>) -> Void)?
    
    func startSignInWithAppleFlow() async throws -> SignInResult {
        try await withCheckedThrowingContinuation({ [weak self] continuation in
            self?.signInWithAppleFlow { result in
                continuation.resume(with: result)
                return
            }
        })
    }
    
    private func signInWithAppleFlow(completion: @escaping (Result<SignInResult, Error>) -> Void) {
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(NSError()))
            return
        }
        
        let nonce = HelperFunctions.randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = HelperFunctions.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    
}

extension SignInApple: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor(frame: .zero)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce, let completion = completionHandler else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion(.failure(NSError()))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion(.failure(NSError()))
                return
            }
            
            let appleResult = SignInResult(idToken: idTokenString, nonce: nonce)
            completion(.success(appleResult))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

