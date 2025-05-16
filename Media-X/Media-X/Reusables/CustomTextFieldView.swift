//
//  CustomTextFieldView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI


struct CustomTextFieldView:View {
    let placeHolder:String
    let icon:String
    let isSecured:Bool
    @Binding var text:String
    var body: some View {
        if isSecured {
            SecureField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    HStack {
                        Image(systemName:icon )
                            .font(.system(size: 20))
                        Text(placeHolder)
                    }
                    .foregroundStyle(.gray)
                }
                .padding()
                .background(._898_A_83.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))

        }else{
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    HStack {
                        Image(systemName:icon )
                            .font(.system(size: 20))
                        Text(placeHolder)
                    }
                    .foregroundStyle(.gray)
                }
                .padding()
                .background(._898_A_83.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
