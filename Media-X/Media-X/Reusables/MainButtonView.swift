//
//  MainButtonView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI


struct MainButtonView:View {
    let title:String
    let isDisabled:Bool
    let action:()->()
    var body: some View {
        Button {
            action()
        }label: {
            Text(title)
                .font(.custom(CustomFonts.playFairMediym, size: 20))
                .foregroundStyle(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? .gray:._3_B_9678)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isDisabled)
    }
}
