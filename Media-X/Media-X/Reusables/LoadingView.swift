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
            ActivityIndicatorView(
                isVisible: $isLoading,
                type: .arcs(count: 3, lineWidth: 2)
            )
                .frame(width:200,height: 200)
                .foregroundStyle(.A_8_E_6_CF)
                .onAppear{
                    globalLoading.isLoading = true
                }
                .onDisappear {
                    globalLoading.isLoading = false
                }
        }
    }
}
