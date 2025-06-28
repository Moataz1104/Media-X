//
//  UIViewController+Extension.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import Foundation
import AuthenticationServices

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

