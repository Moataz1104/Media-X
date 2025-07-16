//
//  FollowersView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 03/07/2025.
//

import SwiftUI

struct FollowersView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @StateObject private var viewModel = FollowersViewModel()
    @Environment(\.dismiss) var dismiss
    @State var screenState : FollowersScreenState
    @State var userId:String
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                        .customFont(.bold, size: 20)
                        .foregroundStyle(._3_B_9678)
                }
                Spacer()
                Text(screenState.rawValue)
                    .customFont(.bold, size: 20)
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.left")
                    .customFont(.bold, size: 20)
                    .foregroundStyle(._3_B_9678)
                    .hidden()
                
            }
            .padding([.horizontal,.top])
            SearchTextField(text: $viewModel.searchInput)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.filteredUsers) { user in
                    GeneralUserCellView(user: user) {
                        viewModel.handleFollow(userId: self.userId,isFollower: user.isFollower ?? false)
                    }ontapAction: {
                        navigationStateManager.pushToStage(stage: .profileView(id: user.id.uuidString))
                    }
                }
            }
        }
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.userId = userId
            viewModel.screenState = self.screenState
            viewModel.getUsers()
        }
    }
}
