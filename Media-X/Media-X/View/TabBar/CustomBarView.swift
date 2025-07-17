//
//  CustomBarView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct CustomBarView: View {
    @Binding var selectedTab:Int
    @State private var showAlert = false
    @State private var showAddPostSheet = false
    @EnvironmentObject var uploadPostVM : UploadPostViewModel
    var body: some View {
        
            HStack{
                
                Spacer()
                TabBarButtonView(selectedTab: $selectedTab,icon:.homeIcon, index: 0){
                    withAnimation {
                        selectedTab = 0
                    }
                }
                
                Spacer()
                TabBarButtonView(selectedTab: $selectedTab,icon:.searchIcon, index: 1){
                    withAnimation {
                        selectedTab = 1
                    }
                }
                Spacer()
                TabBarButtonView(selectedTab: $selectedTab,icon:.plusIcon, index: 2){
                    if !uploadPostVM.isLoading{
                        showAddPostSheet = true
                    }
                }
                Spacer()
                
                TabBarButtonView(selectedTab: $selectedTab,icon:.notificationIcon, index: 3){
                    withAnimation {
                        selectedTab = 3
                    }
                }
                Spacer()
                
                TabBarButtonView(selectedTab: $selectedTab,icon:.profileBarIcon, index: 4){
                    withAnimation {
                        selectedTab = 4
                    }
                }
                Spacer()
            }
            .padding(.top)
            .frame(height: 100,alignment: .top)
            .sheet(isPresented: $showAddPostSheet) {
                AddPostView(showAddPostSheet:$showAddPostSheet, type: .post)
            }
    }
}




