//
//  KeyboardObserver.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation
import SwiftUI
class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        DispatchQueue.main.async{
            withAnimation {
                self.isKeyboardVisible = true
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        DispatchQueue.main.async{
            withAnimation {
                self.isKeyboardVisible = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

