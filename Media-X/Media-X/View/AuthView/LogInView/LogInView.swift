//
//  LogInView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var viewModel = LogInViewModel()
    @StateObject private var keyBoardManager = KeyboardObserver()
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    var body: some View {
        ZStack(alignment:keyBoardManager.isKeyboardVisible ? .top:.bottom){
            Color
                ._3_B_9678
                .onReceive(viewModel.navigationSubject) {
                    navigationStateManager.pushToStage(stage: .tabBar)
                }
            
            VStack(spacing:50) {
                TopSheetRecView()
                
                Text("Welcome Back")
                    .customFont(.bold, size: 32)
                    .frame(maxWidth: .infinity,alignment: .leading)
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
                    
                }
                
                
                VStack {
                    
                    MainButtonView(
                        title: "Log In",
                        isDisabled: viewModel.isButtonDisabled()){
                            viewModel.sendRequest()
                        }
                    
                    
                    HStack {
                        Text("Do not have account ?")
                            .customFont(.regular, size: 15)
                        
                        Button {
                            navigationStateManager.pushToStage(stage: .register)
                        }label: {
                            Text("Sign Up")
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
            .padding(.top , keyBoardManager.isKeyboardVisible ? 80 : 0)

            if viewModel.isLoading {
                LoadingView(isLoading: $viewModel.isLoading)
            }
            
            if viewModel.showError {
                
                Color
                    .black
                    .opacity(0.5)
                    .onTapGesture {
                        viewModel.showError = false
                    }
                VStack {
                    Spacer()
                    ErrorView(errorMessage: viewModel.errorMessage) {
                        viewModel.showError = false
                    }
                    .frame(width: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .dismissKeyboardOnTap()
    }
}

#Preview {
    LogInView()
}
