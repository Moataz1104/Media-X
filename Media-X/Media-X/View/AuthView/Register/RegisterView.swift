//
//  RegisterView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    var body: some View {
        ZStack{
            VStack {
                Text("Media X")
                    .customFont(.leckerli, size: 50)
                    .foregroundStyle(._3_B_9678)
                    .padding(.top,50)
                Spacer()
                
                VStack(spacing:20) {
                    
                    CustomTextFieldView(
                        placeHolder: "Enter Your Email address",
                        icon: "envelope",
                        isSecured: false,
                        text: $viewModel.email
                    )
                    CustomTextFieldView(
                        placeHolder: "Enter Password",
                        icon: "lock",
                        isSecured: true,
                        text: $viewModel.passWord
                    )
                    CustomTextFieldView(
                        placeHolder: "Confirm Password",
                        icon: "lock",
                        isSecured: true,
                        text: $viewModel.confPassword
                    )
                    
                }
                Spacer()
                MainButtonView(title: "Register", isDisabled: false) {
                    viewModel.register()
                }
                .padding(.bottom,30)
                HStack {
                    Text("Already have account ?")
                        .customFont(.regular, size: 15)
                    
                    Button {
                        dismiss()
                    }label: {
                        Text("Log In")
                            .customFont(.regular, size: 15)
                            .foregroundStyle(._3_B_9678)
                    }
                }
            }
            .padding()
            if viewModel.isLoading {
                LoadingView(isLoading: $viewModel.isLoading)
            }
        }
        .onReceive(viewModel.successSubject, perform: { _ in
            navigationStateManager.pushToStage(stage: .userForm)
        })
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
        .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, actions: {}, message: {
            Text(viewModel.errorMessage)
        })
    }
}
