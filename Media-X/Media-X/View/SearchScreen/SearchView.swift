//
//  SearchView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/07/2025.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>

    @StateObject private var viewModel = SearchViewModel()
    var body: some View {
        VStack {
            VStack {
                Text("Search")
                    .customFont(.bold, size: 30)
                    .foregroundStyle(.black)
                
                SearchTextField(text: $viewModel.searchInput)
            }
            .padding([.top,.horizontal])
            
            ScrollView(showsIndicators:false) {
                VStack {
                    if viewModel.searchResults.isEmpty {
                        ForEach(viewModel.recentSearches) { model in
                            RecentUserCellView(user: model) {
                                viewModel.removeRecent(searchedUser:model.id)
                            }ontapAction: {
                                navigationStateManager.pushToStage(stage: .profileView(id: model.id.uuidString))
                            }
                        }
                        
                    }else {
                        ForEach(viewModel.searchResults) { model in
                            GeneralUserCellView(user: model) {
                                viewModel.handleFollow(userId: model.id.uuidString,isFollower: model.isFollower ?? false)
                            }ontapAction: {
                                viewModel.uploadRecentSearch(userModel: model)
                                navigationStateManager.pushToStage(stage: .profileView(id: model.id.uuidString))
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
        .background(.white)
        .dismissKeyboardOnTap()
    }
}

struct RecentUserCellView:View {
    let user:SBUserModel
    let action:()->Void
    let ontapAction: () -> ()
    var body: some View {
        HStack {
            if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(user.imageId)") {
                ImageBorderView(imageUrl: url)
                    .frame(width: 80,height: 80)
            }
            Text(user.name)
                .customFont(.medium, size: 20)
            
            Spacer()

            Button {
                action()
            }label: {
                Image(systemName: "xmark")
                    .customFont(.medium, size: 20)
                    .foregroundStyle(._3_B_9678)
            }
        }
        .padding(.horizontal)
        .contentShape(.rect)
        .onTapGesture {
            ontapAction()
        }
    }
}
