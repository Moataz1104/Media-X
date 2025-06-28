//
//  LogInViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation
import SwiftKeychainWrapper
import Combine

class LogInViewModel : ObservableObject {
    
    @Published var email:String = IS_TESTING ? Constants.MOCK_EMAIL:""
    @Published var passWord:String = IS_TESTING ? Constants.MOCK_PASSWORD:""
    @Published var isLoading:Bool = false
    @Published var showError:Bool = false
    @Published var errorMessage:String = ""
    let navigationSubject = PassthroughSubject<Void, Never> ()
    private let authService : AuthService
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func sendRequest() {
        isLoading = true
        Task {[weak self] in
            guard let self = self else{return}
            let result = await authService.logInUser(email: email, password: passWord)
            
            switch result {
            case .success(let token):
                print("authService.logInUser\n\(token)")
                KeychainWrapper.standard.set(token, forKey: Constants.TOKEN)
                UserDefaults.standard.set(Date(), forKey: Constants.LOG_IN_TIME_STAMP)
                await MainActor.run {
                    self.navigationSubject.send(())
                }
            case .failure(let failure):
                await MainActor.run {
                    self.showError = true
                    self.errorMessage = failure.localizedDescription
                    if failure.localizedDescription == Constants.ERROR_MESSAGE {
                        self.errorMessage += Constants.ERROR_COMPLETION
                    }
                }
                
                print(failure.localizedDescription)
                
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func isButtonDisabled() -> Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || passWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
