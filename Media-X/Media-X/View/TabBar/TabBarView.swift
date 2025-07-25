//
//  TabBarView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var globalLoading : GlobalLoading
    @EnvironmentObject var globalUser : GlobalUser
    @State private var selectedTab = 0
    @EnvironmentObject var uploadPostVM : UploadPostViewModel
    @State private var progressWidth : Double = 0.0
    @EnvironmentObject var storyVM : StoryViewModel
    var body: some View {
        ZStack(alignment:.top) {
            ZStack{
                Color
                    ._3_B_9678
                    .ignoresSafeArea()
                VStack(spacing:0){
                    Group {
                        switch selectedTab {
                        case 0 :
                            HomeView(postId: nil)
                                .padding(.top,40)
                        case 1:
                            SearchView()
                                .padding(.top,40)
                        case 2 :
                            Text("")
                        case 3 :
                            NotificationView()
                                .padding(.top,40)
                        case 4 :
                            ProfileView(userId:globalUser.user?.id.uuidString ?? "",showBackButton:false)
                                .padding(.top,60)
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
            
            if uploadPostVM.isLoading {
                Rectangle()
                    .frame(height: 140)
                    .foregroundStyle(._3_B_9678)
                    .onAppear {
                        uploadPostVM.uploadingProgress = 0
                    }
                    .overlay(alignment:.bottom) {
                        if uploadPostVM.uploadingProgress < 1 {
                            VStack(alignment:.leading) {
                                Text("Uploading \(uploadPostVM.uploadType?.rawValue ?? "")...")
                                    .customFont(.medium, size: 20)
                                    .foregroundStyle(.white)
                                ZStack(alignment:.leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white.opacity(0.3))
                                        .frame(height: 3)
                                    
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                        .frame(width: uploadPostVM.uploadingProgress * progressWidth,height: 3)
                                    
                                }
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                progressWidth = geo.size.width
                                            }
                                            .onChange(of: geo.size.width) { _,newWidth in
                                                progressWidth = newWidth
                                            }
                                    }
                                )
                            }
                            .padding()
                            .padding(.bottom)
                        }else {
                            HStack {
                                Text("\(uploadPostVM.uploadType?.rawValue ?? "") Uploaded Successfully")
                                    .customFont(.bold, size: 18)
                                    .foregroundStyle(.white)

                                Image(systemName: "checkmark")
                                    .customFont(.bold, size: 18)
                                    .foregroundStyle(._3_B_9678)
                                    .padding()
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onAppear {
                                        storyVM.refresh()
                                    }
                            }
                            .padding(.bottom)
                        }
                    }
                    .ignoresSafeArea()
            }
            
            if !storyVM.storyDetails.isEmpty {
                StorySheetView(
                    isMyStory:globalUser.user?.id == storyVM.storyDetails[0].user.id,
                               models: storyVM.storyDetails) {
                    withAnimation {
                        storyVM.storyDetails = []
                    }
                }
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}
