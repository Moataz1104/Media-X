//
//  LoadingView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI
import ActivityIndicatorView

struct LoadingView: View {
    @EnvironmentObject var globalLoading : GlobalLoading
    @Binding var isLoading:Bool
    var body: some View {
        ZStack {
            Color
                .black
                .opacity(0.5)
                .ignoresSafeArea()
            ActivityIndicatorView(isVisible: $isLoading, type: .rotatingDots(count: 5))
                .frame(width:200,height: 200)
                .foregroundStyle(._3_B_9678)
                .onAppear{
                    globalLoading.isLoading = true
                }
                .onDisappear {
                    globalLoading.isLoading = false
                }
        }
    }
}
