//
//  RegisterViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import Combine
@MainActor
class RegisterViewModel : ObservableObject {
    @Published var email:String = ""
    @Published var passWord:String = ""
    @Published var confPassword:String = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var isLoading = false

    
    var subject = PassthroughSubject<SBUserModel?, Never> ()
    var successSubject = PassthroughSubject<Void,Never>()
    
    
    @MainActor
    func register() {
        guard isValidateIntputs() else{return}
        isLoading = true
        Task {
            do {
                try await AuthManager.shared.signUpEmail(email: email, password: passWord)
                successSubject.send(())
            }catch{
                print(error.localizedDescription)
                showAlert = true
                errorTitle = "Invalid"
                errorMessage = error.localizedDescription
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
    
    private func isValidateIntputs() -> Bool {
        
        guard Validation.isValidEmail(email)else {
            showAlert = true
            errorTitle = Validation.AlertType.invalidEmail.title
            errorMessage = Validation.AlertType.invalidEmail.message
            return false
        }
        
        
        
        guard Validation.isPasswordsEqual(p1: passWord, p2: confPassword)else {
            showAlert = true
            errorTitle = Validation.AlertType.passwordNotEqual.title
            errorMessage = Validation.AlertType.passwordNotEqual.message
            return false
        }
        
        return true
    }

}
