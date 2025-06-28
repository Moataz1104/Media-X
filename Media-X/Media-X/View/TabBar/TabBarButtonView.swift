//
//  TabBarButtonView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct TabBarButtonView:View {
    @Binding var selectedTab:Int
    let icon : ImageResource
    let index: Int
    let action:() -> ()
    var body: some View {
        Button{
            action()
        }label: {
            VStack(spacing:10){
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25,height: 25)
                    .foregroundStyle(.white)
                
                if selectedTab == index{
                    Circle()
                        .frame(width: 5,height: 5)
                        .foregroundStyle(.white)
                }
            }
        }

    }
}
