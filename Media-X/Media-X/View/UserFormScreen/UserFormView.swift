//
//  UserFormView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 28/06/2025.
//

import SwiftUI

struct UserFormView: View {
    @StateObject private var viewModel = UserFormViewModel()
    @State private var showPicker: Bool = false
    @EnvironmentObject var globalUser:GlobalUser
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @EnvironmentObject var homeVM:HomeViewModel
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Media-X")
                        .customFont(.leckerli, size: 50)
                        .foregroundStyle(._3_B_9678)
                    Spacer()
                }
                
                VStack(spacing:30) {
                    Group {
                        if let data = viewModel.imageData,
                           let uiImage = UIImage(data: data){
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(.circle)
                        }else{
                            Circle()
                                .fill(.gray.gradient)
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .onTapGesture {
                        showPicker = true
                    }
                    .overlay(alignment: .bottomTrailing) {
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
                    
                    
                    
                    CustomTextFieldView(
                        placeHolder: "Enter Your Name",
                        icon: "person",
                        isSecured: false,
                        text: $viewModel.username
                    )
                }
                
                
                
                Spacer()
                
                MainButtonView(title: "Continue", isDisabled: viewModel.isButtonDisabled()) {
                    viewModel.uploadData()
                }
            }
            .padding()
            
            if viewModel.isLoading {
                LoadingView(isLoading: $viewModel.isLoading)
            }
        }
        .onReceive(viewModel.userSubject, perform: { user in
            if let user = user {
                globalUser.user = user
                navigationStateManager.pushToStage(stage: .tabBar)
                homeVM.fetchPosts()
            }
        })
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImageData: $viewModel.imageData)
        }
    }
}

#Preview {
    UserFormView()
}
