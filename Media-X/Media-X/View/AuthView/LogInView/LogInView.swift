//
//  LogInView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var keyBoardManager = KeyboardObserver()
    var body: some View {
        ZStack(alignment:keyBoardManager.isKeyboardVisible ? .top:.bottom){
            Color
                ._3_B_9678
                
            
            VStack(spacing:50) {
                TopSheetRecView()
                
                Text("Welcome Back")
                    .font(.custom(CustomFonts.playFairBold, size: 32))
                    .frame(maxWidth: .infinity,alignment: .leading)
                VStack(spacing:20) {
                    
                    CustomTextFieldView(
                        placeHolder: "Enter Your Email address",
                        icon: "envelope",
                        isSecured: false,
                        text: .constant("")
                    )
                    CustomTextFieldView(
                        placeHolder: "Enter Password",
                        icon: "lock",
                        isSecured: true,
                        text: .constant("")
                    )
                    
                }
                
                
                VStack {
                    
                    MainButtonView(
                        title: "Log In",
                        isDisabled: false){}
                    
                    
                    HStack {
                        Text("Do not have account ?")
                            .font(.custom(CustomFonts.playFairRegular, size: 15))
                        
                        Button {
                            
                        }label: {
                            Text("Sign Up")
                                .font(.custom(CustomFonts.playFairRegular, size: 15))
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

            
        }
        .ignoresSafeArea()
        .dismissKeyboardOnTap()
    }
}

#Preview {
    LogInView()
}
