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
            VStack(spacing:0){
                
                switch selectedTab {
                case 0 :
                    Color
                        .blue
                case 1:
                    Color
                        .blue
                case 2:
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
                
                
//                Spacer()
                CustomBarView(selectedTab: $selectedTab)
                
            }
            .ignoresSafeArea(edges:.bottom)
            if globalLoading.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
        }
        
        .navigationBarBackButtonHidden()
        
    }
}
