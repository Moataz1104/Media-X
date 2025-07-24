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
    let dataClosure:(SBUserModel)->()
    var body: some View {
        ZStack{
            VStack {
                Text("Media X")
                    .customFont(.leckerli, size: 50)
                    .foregroundStyle(._3_B_9678)
                    .padding(.top,50)
                Spacer()
                
                VStack {
                    
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
                    
                    
                    VStack(spacing:40) {
                        MainButtonView(title: "Register", isDisabled: false) {
                            viewModel.register()
                        }
                        .padding(.bottom,30)
                        HStack(spacing:30){
                            
                            Rectangle()
                                .frame(height: 1)
                            
                            Text("OR")
                                .customFont(.regular, size: 14)
                            Rectangle()
                                .frame(height: 1)
                        }
                        .foregroundStyle(.gray)
                        .padding(.horizontal,25)
                        
                        
                        Button{
                            viewModel.signInWithGoogle()
                        }label:{
                            HStack {
                                Image("googleLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24)
                                Text("Continue with Google")
                                    .customFont(.regular, size: 20)
                            }
                            .frame(maxWidth: 600)
                            .frame(height: 55)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(uiColor: UIColor.lightGray) , lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top,20 )
                }
                
                Spacer()
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
        .onReceive(viewModel.subject){value in
            if let value = value {
                dataClosure(value)
                navigationStateManager.pushToStage(stage: .tabBar)
                
            }else{
                navigationStateManager.pushToStage(stage: .userForm)
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
