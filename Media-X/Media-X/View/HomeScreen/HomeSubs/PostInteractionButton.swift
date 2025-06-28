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
    let action:()->()
    var body: some View {
        Button {
            action()
        }label: {
            HStack {
                Image(systemName: icon)
                    .customFont(.medium, size: 20)
                    .foregroundStyle(.black)
                
                Text(count)
                    .customFont(.regular, size: 15)
                    .foregroundStyle(.black)
            }
        }
    }
}
