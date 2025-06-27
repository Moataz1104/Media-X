//
//  RegisterViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/05/2025.
//

import Foundation
import Combine

class RegisterViewModel:ObservableObject {
    @Published var name:String = ""
    @Published var email:String = ""
    @Published var passWord:String = ""
    @Published var confPassword:String = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    var registerSuccessSubject = PassthroughSubject<Void,Never>()
    private let authService:AuthServiceProtocol
    
    init() {
        authService = AuthService()
    }
    
    @MainActor
    func registerUser(){
        guard isValidateIntputs() else{return}
        isLoading = true
        Task {
            let result = await authService.registerUser(
                userName: name,
                email: email,
                password: passWord,
                images: []
            )
            switch result {
            case .success(_):
                print("registerUser success")
                registerSuccessSubject.send(())
            case .failure(let failure):
                print(failure.localizedDescription)
                errorTitle = "Error"
                errorMessage = failure.localizedDescription
                showAlert = true
            }
            isLoading = false
        }
        
        
    }
    
    
    
    func isValidateIntputs() -> Bool {
        guard Validation.isValidUserName(name)else {
            showAlert = true
            errorTitle = Validation.AlertType.invalidUerName.title
            errorMessage = Validation.AlertType.invalidUerName.message
            return false
        }
        
        guard Validation.isValidEmail(email)else {
            showAlert = true
            errorTitle = Validation.AlertType.invalidEmail.title
            errorMessage = Validation.AlertType.invalidEmail.message
            return false
        }
        
        guard Validation.isPasswordValid(passWord)else {
            showAlert = true
            errorTitle = Validation.AlertType.invalidPassword.title
            errorMessage = Validation.AlertType.invalidPassword.message
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
