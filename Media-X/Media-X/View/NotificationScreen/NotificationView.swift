//
//  NotificationView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @Namespace private var tabAnimation
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.updateAllNotificationsToRead()
                    }label: {
                        Text("Mark all as read")
                            .customFont(.medium, size: 14)
                            .foregroundStyle(.black.opacity(0.5))
                    }
                }
                .padding([.horizontal,.top])
                VStack(alignment:.center,spacing:0){
                    Text("Notifications")
                        .customFont(.medium, size: 28)
                        .foregroundStyle(.black)
                        .padding([.top])
                        .padding(.top)
                    if viewModel.notifications.isEmpty, !viewModel.isLoading {
                        VStack{
                            Spacer()
                            Text("No Notifications")
                                .customFont(.medium, size: 20)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }else {
                        ScrollView(showsIndicators:false) {
                            VStack(spacing:0.5) {
                                ForEach(viewModel.notifications,id:\.id) { model in
                                    NotificationCellView(model: model) {
                                        Task {
                                            await viewModel.updateNotificationToRead(model: model)
                                        }
                                        if let id = model.postId {
                                            navigationStateManager.pushToStage(stage: .homeView(id))
                                        }else {
                                            navigationStateManager.pushToStage(stage: .profileView(id: model.from.uuidString))
                                        }
                                    }
                                }
                            }
                            .background(.black.opacity(0.5))
                            .padding(.top)
                            .padding(.bottom,100)
                        }
                        .refreshable {
                            viewModel.fetchNotifications()
                        }
                    }
                }
            }
            if viewModel.isLoading {
                LoadingView( isLoading: $viewModel.isLoading)
            }
        }
        .background(.white)
        .onChange(of: viewModel.selectedTab) { oldValue, newValue in
            viewModel.handleNewTab()
        }
    }
    @ViewBuilder
    private func TabSelector() -> some View {
        HStack {
            ForEach(NotificationTabType.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            viewModel.selectedTab = tab
                        }
                    } label: {
                        
                        Text(tab.rawValue)
                            .customFont(.medium, size: 14)
                            .foregroundColor(viewModel.selectedTab == tab ? ._3_B_9678 : .black)
                    }
                    
                    if viewModel.selectedTab == tab {
                        Capsule()
                            .fill(._3_B_9678)
                            .matchedGeometryEffect(id: "underline", in: tabAnimation)
                            .frame(height: 2)
                            .frame(maxWidth: 60)
                    } else {
                        Color.clear.frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }
}


struct NotificationCellView:View {
    let model:SBNotification
    let action:()->Void
    var body: some View {
        Button {
            action()
        }label: {
            HStack {
                if let imageId = model.imageId,
                   let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(imageId)") {
                    ImageBorderView(imageUrl: url)
                        .frame(width: 50,height: 50)
                }
                VStack(alignment:.leading,spacing:4) {
                    if let action = NotificationAction(rawValue: model.action) {
                        Text(action.getNotificationTitle(userName: model.username ?? ""))
                            .customFont(.medium, size: 15)
                            .foregroundStyle(.black)
                    }
                    
                    
                    Text(HelperFunctions.formatTimeString(from: model.dateString ?? ""))
                        .customFont(.medium, size: 12)
                        .foregroundStyle(.gray)
                    
                }
                
                
                Spacer()
                if !model.watched {
                    Circle()
                        .foregroundStyle(._3_B_9678)
                        .frame(width: 8,height: 8)
                }
            }
            .padding()
            .frame(height: 80)
            .background(.F_6_F_8_FA)
        }
    }
    
    
}
