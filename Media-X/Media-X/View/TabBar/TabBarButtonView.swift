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
                    .frame(width:selectedTab == index ? 20 : 25, height: selectedTab == index ? 20 : 25)
                    .foregroundStyle(selectedTab == index ? .white: .gray)
                    .frame(width: 50, height: 50)
                    .background(
                        selectedTab == index ? LinearGradient(
                            colors: [._1_C_3_F_3_A , ._3_B_9678 , .A_8_E_6_CF],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) : LinearGradient(
                            colors: [.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(.circle)
                
//                if selectedTab == index{
//                    Circle()
//                        .frame(width: 5,height: 5)
//                        .foregroundStyle(._3_B_9678)
//                }
            }
        }

    }
}
