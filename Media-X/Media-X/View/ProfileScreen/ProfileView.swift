//
//  ProfileView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI
import Kingfisher
struct ProfileView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @EnvironmentObject var globalUser:GlobalUser
    @Environment(\.dismiss) var dismiss
    @Namespace private var tabAnimation
    @State private var onTapId :UUID?
    @FocusState private var isUsernameFieldFocused: Bool
    
    @StateObject private var viewModel = ProfileViewModel()
    @State var userId:String
    @State private var posts:[SBFetchedPost] = []
    @State var showBackButton:Bool = true
    var body: some View {
        ZStack {
            
            if viewModel.loading {
                LoadingView(isLoading: $viewModel.loading)
            }else {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        }label: {
                            if showBackButton {
                                Image(systemName: "chevron.left")
                                    .customFont(.bold, size: 20)
                                    .foregroundStyle(._3_B_9678)
                            }else {
                                Image(systemName: "chevron.left")
                                    .customFont(.bold, size: 20)
                                    .foregroundStyle(._3_B_9678)
                                    .hidden()
                            }
                        }
                        .padding([.top,.horizontal])
                        Spacer()
                    }
                    ScrollView(showsIndicators: false) {
                        VStack {
                            headerView()
                                .padding(.horizontal)
                            
                            TabView()
                            
                            
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        Task {
                            await viewModel.fetchPosts(userId: self.userId)
                        }
                    }
                }
                if let _ = onTapId  {
                    ProfileFeedsView(scrollId: $onTapId, posts: $posts)
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            
        }
        .onAppear {
            Task {
                if let uid = UUID(uuidString: self.userId) {
                    viewModel.userId = self.userId
                    viewModel.isMyProfile = viewModel.isMyProfile(id: self.userId)
                    if viewModel.isMyProfile! {
                        viewModel.username = globalUser.user?.name ?? ""
                        viewModel.imageId = globalUser.user?.imageId ?? ""
                        viewModel.tempUserName = viewModel.username
                    }else {
                        let user = try await viewModel.getUserData(userId: uid)
                        viewModel.username = user?.name ?? ""
                        viewModel.imageId = user?.imageId
                        viewModel.tempUserName = viewModel.username
                    }
                }
                
                await viewModel.fetchPosts(userId: self.userId)
            }
        }
        .background(.white)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImageData: $viewModel.imageData)
                .onChange(of: viewModel.imageData) { oldValue, newValue in
                    if let _ = newValue {
                        viewModel.showImagePicker = false
                    }
                }
        }
    }
    
    @ViewBuilder
    private func ProfileImage() -> some View {
        if let isMyProfile = viewModel.isMyProfile, isMyProfile {
            
            Group {
                if let data = viewModel.imageData {
                    Image(uiImage:UIImage(data: data) ?? .bigLike)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(.circle)
                    
                }else if let imageId = viewModel.imageId ,
                         let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(imageId)") {
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                    
                }
            }
            .overlay{
                Circle()
                    .stroke(.white,lineWidth: 5)
                    .overlay {
                        Circle()
                            .stroke(._3_B_9678,lineWidth: 3)
                    }
            }
            .onTapGesture {
                if viewModel.isEditingProfile {
                    viewModel.showImagePicker = true
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if isMyProfile && viewModel.isEditingProfile {
                    Circle()
                        .fill(._3_B_9678)
                        .overlay {
                            Image(.camera)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                        }
                        .frame(width: 32, height: 32)
                }
            }
            .disabled(!viewModel.isEditingProfile)
            
        } else if let imageId = viewModel.imageId ,
                  let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(imageId)") {
            KFImage(url)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(.circle)
        }
        
    }
    @ViewBuilder
    private func TabView() -> some View {
        VStack(spacing: 0) {
            if let isMyProfile = viewModel.isMyProfile,isMyProfile {
                TabSelector()
                Divider()
            }else {
                if let isFollower = viewModel.isFollower {
                    Button {
                        viewModel.handleFollow()
                    }label: {
                        Text(isFollower ? "Following": "Follow")
                            .foregroundStyle(.white)
                            .padding(.vertical,10)
                            .frame(width: 150)
                            .background(isFollower ? .gray:._3_B_9678)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.bottom)
                    }
                }
            }
            if viewModel.selectedTab == .photos {
                ProfilePhotosGrid(posts: viewModel.posts) {id in
                    withAnimation {
                        self.onTapId = id
                        posts = viewModel.selectedTab == .photos ? viewModel.posts : viewModel.bookmarks
                    }
                }
            } else {
                ProfilePhotosGrid(posts:viewModel.bookmarks) { id in
                    withAnimation {
                        self.onTapId = id
                        posts = viewModel.selectedTab == .photos ? viewModel.posts : viewModel.bookmarks
                    }
                }
            }
        }
        .padding(.top, 24)
    }
    
    @ViewBuilder
    private func TabSelector() -> some View {
        HStack {
            ForEach(TabType.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            viewModel.selectedTab = tab
                        }
                    } label: {
                        Image(tab.icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(viewModel.selectedTab == tab ? ._3_B_9678 : .black)
                            .frame(height: 25)
                        
                        
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
    
    
    private func headerView() -> some View {
        VStack {
            HStack(spacing:20){
                
                VStack (alignment:.leading){
                    HStack(spacing:20) {
                        ProfileImage()
                        
                        VStack(alignment:.leading) {
                            TextField("User Name...", text: $viewModel.username)
                                .multilineTextAlignment(.leading)
                                .customFont(.bold, size: 25)
                                .foregroundStyle(.black)
                                .fixedSize()
                                .disabled(!viewModel.isEditingProfile)
                                .focused($isUsernameFieldFocused)
                                .onChange(of: viewModel.isEditingProfile) { _, newValue in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isUsernameFieldFocused = newValue
                                    }
                                }
                            
                            
                            if viewModel.isEditingProfile {
                                HStack {
                                    Button {
                                        if let isMyProfile = viewModel.isMyProfile, isMyProfile {
                                            if viewModel.isEditingProfile {
                                                
                                                globalUser.updateUser(
                                                    userName: viewModel.username,
                                                    oldImageId: viewModel.imageId,
                                                    newImageData: viewModel.imageData
                                                )
                                                
                                                withAnimation(.smooth) {
                                                    viewModel.isEditingProfile = false
                                                }
                                                
                                            }else {
                                                withAnimation(.smooth) {
                                                    viewModel.isEditingProfile = true
                                                }
                                            }
                                        }
                                        
                                        UIApplication.shared.sendAction(
                                            #selector(UIResponder.resignFirstResponder),
                                            to: nil,
                                            from: nil,
                                            for: nil
                                        )
                                        
                                    }label: {
                                        Text("Save")
                                            .customFont(.medium, size: 20)
                                            .foregroundStyle(.white)
                                            .padding(.horizontal,10)
                                            .frame(height: 35)
                                            .background(._3_B_9678)
                                            .clipShape(RoundedRectangle(cornerRadius: 300))
                                    }
                                    
                                    Button {
                                        withAnimation{
                                            viewModel.isEditingProfile = false
                                        }
                                        UIApplication.shared.sendAction(
                                            #selector(UIResponder.resignFirstResponder),
                                            to: nil,
                                            from: nil,
                                            for: nil
                                        )
                                        
                                        viewModel.imageData = nil
                                        viewModel.username = viewModel.tempUserName
                                        
                                    }label: {
                                        Text("Cancel")
                                            .customFont(.medium, size: 20)
                                            .foregroundStyle(.gray)
                                            .padding(.horizontal,10)
                                            .frame(height: 35)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 300)
                                                    .stroke(.gray, lineWidth: 1)
                                            }
                                    }
                                }
                            }else {
                                if let isMyProfile = viewModel.isMyProfile, isMyProfile {
                                    HStack {
                                        Button {
                                            withAnimation{
                                                viewModel.isEditingProfile = true
                                            }
                                        }label: {
                                            Text("Edit")
                                                .customFont(.medium, size: 20)
                                                .foregroundStyle(.white)
                                                .padding(.horizontal,10)
                                                .frame(height: 35)
                                                .background(._3_B_9678)
                                                .clipShape(RoundedRectangle(cornerRadius: 300))
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                    HStack {
                        Spacer()
                        stateView(count: viewModel.selectedTab == .photos ? "\(viewModel.postsCount)" : "\(viewModel.bookmarks.count)", text: "Posts")
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundStyle(.gray.opacity(0.5))
                        Spacer()
                        stateView(count: "\(viewModel.followersCount)", text: "followers")
                            .onTapGesture {
                                navigationStateManager.pushToStage(stage: .followersScreen(.followers, self.userId))
                            }
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundStyle(.gray.opacity(0.5))
                        Spacer()
                        stateView(count: "\(viewModel.followingCount)", text: "Followings")
                            .onTapGesture {
                                navigationStateManager.pushToStage(stage: .followersScreen(.followings, self.userId))
                            }
                        Spacer()
                    }
                }
                
            }
        }
    }
    private func stateView(count:String,text:String) -> some View {
        VStack {
            Text(count)
                .customFont(.bold, size: 25)
            Text(text)
                .customFont(.regular, size: 17)
                .foregroundStyle(.gray)
            
        }
        
    }
}
