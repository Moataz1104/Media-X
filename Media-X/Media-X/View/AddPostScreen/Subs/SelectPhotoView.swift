//
//  SelectPhotoView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import SwiftUI

struct SelectPhotoView:View {
    @EnvironmentObject var viewModel:AddPostViewModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AddPostNavigationPath>
    var body: some View {
        VStack {
            HStack {
                Text("Next")
                    .customFont(.medium, size: 17)
                    .foregroundStyle(._3_B_9678)
                    .hidden()
                Spacer()
                Text("New \(viewModel.uploadType?.rawValue ?? "")")
                    .customFont(.medium, size: 17)
                    .foregroundStyle(.black)
                Spacer()
                
                Button {
                    navigationStateManager.pushToStage(stage: .addCaption)
                }label: {
                    Text("Next")
                        .customFont(.regular, size: 17)
                        .foregroundStyle(viewModel.imagesData.isEmpty ? .gray : ._3_B_9678)
                }
                .disabled(viewModel.imagesData.isEmpty)
            }
            .padding([.top,.horizontal])
            ScrollView(showsIndicators: false){
                AddPostGridView(images: viewModel.imageList)
                    .environmentObject(viewModel)
            }
        }
        .alert("Max Count is 5 Photos.", isPresented: $viewModel.showError, actions: {})
    }
}
