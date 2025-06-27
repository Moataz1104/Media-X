//
//  RegisterSuccessAlert.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct RegisterSuccessAlert: View {
    var body: some View {
        VStack(spacing:20) {
            Text("Registration Successful!")
                .font(.system(size: 20,weight: .bold))
            
            Image(systemName: "checkmark")
                .font(.system(size: 20,weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .background(.green)
                .clipShape(Circle())
            
            Text("You’ve successfully created your account. Please check your email to confirm your address and activate your account.")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .font(.system(size: 18,weight: .regular))
        }
        .padding()
        .padding(.vertical)
        .background(.white)
    }
}

#Preview {
    RegisterSuccessAlert()
}
