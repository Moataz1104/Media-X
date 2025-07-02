//
//  PostInteractionButton.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct PostInteractionButton:View {
    let icon:String
    let count:String
    let color:Color
    let action:()->()
    var body: some View {
        Button {
            action()
        }label: {
            HStack {
                Image(systemName: icon)
                    .customFont(.medium, size: 25)
                    .foregroundStyle(color)
                
                Text(count)
                    .customFont(.regular, size: 15)
                    .foregroundStyle(.black)
            }
        }
    }
}
