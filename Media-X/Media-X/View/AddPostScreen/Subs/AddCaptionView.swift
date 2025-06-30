//
//  AddCaptionView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import SwiftUI

struct AddCaptionView: View {
    @EnvironmentObject var viewModel:AddPostViewModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AddPostNavigationPath>
    @Environment(\.dismiss) var dismiss
    @Binding var showAddPostSheet:Bool
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                }label: {
                    Text("Back")
                        .customFont(.medium, size: 17)
                        .foregroundStyle(._3_B_9678)
                }
                
                Spacer()
                Text("New post")
                    .customFont(.medium, size: 17)
                    .foregroundStyle(.black)
                Spacer()
                Button {
                    showAddPostSheet = false
                }label: {
                    Text("Publish")
                        .customFont(.regular, size: 17)
                        .foregroundStyle(._3_B_9678)
                }
            }
            
            if let data = viewModel.imageData , let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                
                TextEditor(text: $viewModel.caption)
                    .placeholder(when: viewModel.caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,alignment: .topLeading) {
                        Text("Caption...")
                            .customFont(.regular, size: 15)
                            .foregroundStyle(.gray)
                            .padding([.leading,.top],5)
                    }
                    .frame(height: 300)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

