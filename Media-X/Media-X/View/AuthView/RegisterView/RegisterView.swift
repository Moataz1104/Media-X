//
//  RegisterView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var keyBoardManager = KeyboardObserver()
    var body: some View {
        ZStack(alignment:keyBoardManager.isKeyboardVisible ? .top:.bottom){
            Color
                ._3_B_9678
                
            
            VStack(spacing:50) {
                TopSheetRecView()
                
                contentView()
                VStack {
                    
                    MainButtonView(
                        title: "Register",
                        isDisabled: false){}
                    
                    
                    HStack {
                        Text("Already have account ?")
                            .font(.custom(CustomFonts.playFairRegular, size: 15))
                        
                        Button {
                            
                        }label: {
                            Text("LogIn")
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
            .padding(.top , keyBoardManager.isKeyboardVisible ? 40 : 0)

            
        }
        .ignoresSafeArea()
        .dismissKeyboardOnTap()
    }
    
    private func contentView() -> some View {
        VStack {
            VStack(alignment: .leading,spacing:20){
                Text("Welcome")
                    .font(.custom(CustomFonts.playFairBold, size: 32))
                
                Text("Create Account to keep exploring amazing destinations around the world!")
                    .font(.custom(CustomFonts.playFairRegular, size: 14))
                    .foregroundStyle(.gray)
            }
                .frame(maxWidth: .infinity,alignment: .leading)
            VStack(spacing:20) {
                
                CustomTextFieldView(
                    placeHolder: "Enter Your Name",
                    icon: "person",
                    isSecured: false,
                    text: .constant("")
                )
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
                
                CustomTextFieldView(
                    placeHolder: "Confirm Password",
                    icon: "lock",
                    isSecured: true,
                    text: .constant("")
                )
                
            }
        }
    }
}

#Preview {
    RegisterView()
}
