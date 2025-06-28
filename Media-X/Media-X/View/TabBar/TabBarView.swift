//
//  TabBarView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var globalLoading : GlobalLoading
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack{
            Color
                ._3_B_9678
                .ignoresSafeArea()
            VStack(spacing:0){
                Group {
                    switch selectedTab {
                    case 0 :
                        Color
                            .white
                    case 1:
                        Color
                            .blue
                    case 2 :
                        Color
                            .blue
                    case 3 :
                        Color
                            .blue
                    case 4 :
                        Color
                            .blue
                    default:
                        Text("error")
                    }
                }
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 45,bottomTrailing: 45)))
                
                CustomBarView(selectedTab: $selectedTab)
                
            }
            .ignoresSafeArea()
            
            if globalLoading.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
        }
        
        .navigationBarBackButtonHidden()
        
    }
}
