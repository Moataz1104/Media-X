//
//  AuthManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation


class AuthManager : SupaBaseFunctions{

    static let shared = AuthManager()
    
    private init() {}
        
    
    func signInEmail(email: String, password: String) async throws {
        try await signInWithEmail(email: email, password: password)
    }
    
    func signUpEmail(email: String, password: String) async throws {
        try await signUpWithEmail(email: email, password: password)
    }
    
    func getEmail() -> String? {
        getUserEmail()
    }
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        try await signInWithToken(provider: .apple, idToken: idToken, nonce: nonce)
    }
    
    func signInWithGoogle(idToken: String, nonce: String) async throws {
        try await signInWithToken(provider: .google, idToken: idToken, nonce: nonce)
    }

    func signOutUser() async throws {
        try await signOut()
    }
    
        
    func getUser() async -> SBUserModel? {
        guard let id = getUserUID() else {return nil}
        do {
            let result = try await fetchModelById(id: id,culomnIdName : "id") as Result<[SBUserModel], Error>
            switch result {
            case .success(let data):
                if let user = data.first {
                    return user
                }else{
                    return nil
                }
            case .failure(_):
                return nil
            }
        }catch{
            return nil
        }
    }
    
    func uploadUser(_ user:SBUserModel) async throws -> Result<Void, any Error>  {
        try await uploadModel(user)
    }
    
    func getUID() -> UUID?{
        getUserUID()
    }
}

