//
//  RegisterView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var keyBoardManager = KeyboardObserver()
    @StateObject private var viewModel = RegisterViewModel()
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment:keyBoardManager.isKeyboardVisible ? .top:.bottom){
            Color
                ._3_B_9678
                .onReceive(viewModel.registerSuccessSubject) { _ in
                    showSuccessAlert = true
                }
            
            VStack(spacing:50) {
                TopSheetRecView()
                
                contentView()
                VStack {
                    
                    MainButtonView(
                        title: "Register",
                        isDisabled: false) {
                            viewModel.registerUser()
                        }
                    
                    
                    HStack {
                        Text("Already have account ?")
                            .customFont(.regular, size: 15)
                        
                        Button {
                            dismiss()
                        }label: {
                            Text("LogIn")
                                .customFont(.regular, size: 15)
                                .foregroundStyle(._3_B_9678)
                        }
                    }
                }
                if keyBoardManager.isKeyboardVisible {
                    Spacer()
                }
                
            }
            .padding()
            .padding(.bottom,50)
            .background(.white)
            .clipShape(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30,topTrailing: 30))
            )
            .padding(.top , keyBoardManager.isKeyboardVisible ? 40 : 0)

            if viewModel.showAlert {
                
                Color
                    .black
                    .opacity(0.5)
                    .onTapGesture {
                        viewModel.showAlert = false
                    }
                VStack {
                    Spacer()
                    ErrorView(errorMessage: viewModel.errorMessage) {
                        viewModel.showAlert = false
                    }
                    .frame(width: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    Spacer()
                }
            }
            
            if showSuccessAlert {
                
                Color
                    .black
                    .opacity(0.5)
                VStack {
                    Spacer()
                    RegisterSuccessAlert()
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    Spacer()
                }
                .frame(width: 280)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        dismiss()
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView(isLoading: $viewModel.isLoading)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .dismissKeyboardOnTap()
    }
    
    private func contentView() -> some View {
        VStack {
            VStack(alignment: .leading,spacing:20){
                Text("Welcome")
                    .customFont(.bold, size: 32)
                
                Text("Create Account to keep exploring amazing destinations around the world!")
                    .customFont(.regular, size: 14)
                    .foregroundStyle(.gray)
            }
                .frame(maxWidth: .infinity,alignment: .leading)
            VStack(spacing:20) {
                
                CustomTextFieldView(
                    placeHolder: "Enter Your Name",
                    icon: "person",
                    isSecured: false,
                    text: $viewModel.name
                )
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
        }
    }
}

#Preview {
    RegisterView()
}
