//
//  Validation.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/05/2025.
//


import Foundation

struct Validation{
    
    static func isValidUserName(_ userName : String ) -> Bool{
        userName.count > 3
    }
    
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[^a-zA-Z\\d]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    static func isPasswordsEqual(p1:String , p2:String) -> Bool{
        p1 == p2
    }
    
    enum AlertType {
        case invalidUerName
        case invalidEmail
        case invalidPassword
        case passwordNotEqual
        
        var title: String {
            switch self {
            case .invalidUerName:
                return "Invalid User Name"
            case .invalidEmail:
                return "Invalid E-mail"
            case .invalidPassword:
                return "Invalid Password"
            case .passwordNotEqual:
                return "Reconfirm the password"
                
            }
        }
        
        var message: String {
            switch self {
            case .invalidUerName:
                return "User Name At least 4 characters"
            case .invalidEmail:
                return "The provided e-mail address is not valid."
            case .invalidPassword:
                return "Password must meet the following criteria:\n- At least 8 characters\n- At least 1 uppercase letter\n- At least 1 lowercase letter\n- At least 1 special character"
            case .passwordNotEqual:
                return "Passwords do not match. Please try again."
            }
        }
    }
    
    
}

