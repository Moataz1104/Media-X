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
