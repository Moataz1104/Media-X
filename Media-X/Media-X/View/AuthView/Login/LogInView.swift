//
//  LogInView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var viewModel = LogInViewModel()
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    let dataClosure:(SBUserModel)->()
    var body: some View {
        ZStack{
            VStack {
                Text("Media X")
                    .customFont(.leckerli, size: 50)
                    .foregroundStyle(._3_B_9678)
                Spacer()
                
                VStack(spacing:40) {
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
                        
                    }
                    
                    
                    MainButtonView(title: "Log In", isDisabled: false) {
                        viewModel.signInWithEmail()
                    }
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
                Spacer()
                
                HStack {
                    Text("Do not have account ?")
                        .customFont(.regular, size: 15)
                    
                    Button {
                        navigationStateManager.pushToStage(stage: .register)
                    }label: {
                        Text("Register")
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
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
        .onReceive(viewModel.subject){value in
            if let value = value {
                dataClosure(value)
                navigationStateManager.pushToStage(stage: .tabBar)
                
            }else{
                navigationStateManager.pushToStage(stage: .onBoarding)
            }
        }
        .alert("Invalid", isPresented: $viewModel.showError, actions: {}, message: {
            Text(viewModel.errorMessage)
        })
    }
}

