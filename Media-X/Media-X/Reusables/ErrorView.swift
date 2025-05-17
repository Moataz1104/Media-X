//
//  ErrorView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage:String
    let action:() -> ()
    var body: some View {
        VStack {
            Text("Network Error")
                .font(.custom(CustomFonts.playFairSemiBold, size: 20))
                .foregroundStyle(.black)
            
            Image(.error)
                .resizable()
                .scaledToFit()
                .frame(width: 110)
            
            
            Text(errorMessage)
                .font(.custom(CustomFonts.playFairRegular, size: 16))
                .foregroundStyle(.gray)
            
            Button {
                action()
            }label: {
                Text("OK")
                    .font(.custom(CustomFonts.playFairRegular, size: 20))
                    .foregroundStyle(.white)
                    .frame(minHeight: 50)
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal,50)
            }
        }
        .padding()
        .padding(.vertical)
        .background(.white)
    }
}
