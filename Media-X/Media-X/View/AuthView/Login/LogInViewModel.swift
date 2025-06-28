//
//  LogInViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import Combine

@MainActor
class LogInViewModel : ObservableObject {
    
    @Published var email:String = ""
    @Published var passWord:String = ""
    @Published var isLoading : Bool = false
    @Published var errorMessage = ""
    @Published var showError = false
    private let signInApple = SignInApple()
    private let signInGoogle = SignInGoogle()
    
    var subject = PassthroughSubject<SBUserModel?, Never> ()

    
    func signInWithEmail() {
        isLoading = true
        Task {
            do {
                try await AuthManager.shared.signInEmail(email: email, password: passWord)
            }catch {
                print(error.localizedDescription)
                showError = true
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func signInWithApple() {
        isLoading = true
        Task {[weak self] in
            guard let self = self else{return}
            do {
                let appleResult = try await signInApple.startSignInWithAppleFlow()
                try await AuthManager.shared.signInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
                await self.getUser()
            }
            catch{
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        Task {[weak self] in
            guard let self = self else{return}
            do {
                let googleResult = try await SignInGoogle().startSignInWithGoogleFlow()
                try await AuthManager.shared.signInWithGoogle(
                    idToken: googleResult.idToken,
                    nonce: googleResult.nonce
                )
                await self.getUser()
            }catch{
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }

    
    
    private func getUser() async{
        if let user = await AuthManager.shared.getUser() {
            subject.send(user)
        }else {
            subject.send(nil)
        }
    }

    

}
