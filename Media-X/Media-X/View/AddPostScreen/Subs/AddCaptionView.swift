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
    @EnvironmentObject var uploadPostVM : UploadPostViewModel
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
                Text("New \(viewModel.uploadType?.rawValue ?? "")")
                    .customFont(.medium, size: 17)
                    .foregroundStyle(.black)
                Spacer()
                Button {
                    if viewModel.uploadType == .post {
                        uploadPostVM.uploadPostData(imagesData: viewModel.imagesData, caption: viewModel.caption)
                    }else {
                        uploadPostVM.uploadStoryData(imagesData: viewModel.imagesData, caption: viewModel.caption)
                    }
                    showAddPostSheet = false
                    
                }label: {
                    Text("Publish")
                        .customFont(.regular, size: 17)
                        .foregroundStyle(._3_B_9678)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(viewModel.imagesData,id:\.self) { data in
                        if  let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300,height: 350)
                                .clipShape(.rect(cornerRadius: 8))
                                .overlay(alignment:.topTrailing) {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background(.black.opacity(0.8))
                                        .clipShape(.circle)
                                        .onTapGesture {
                                            if viewModel.imagesData.count == 1 {
                                                viewModel.handleRemoveImageData(data: data)
                                                dismiss()
                                            }else {
                                                viewModel.handleRemoveImageData(data: data)
                                            }
                                        }
                                        .padding()
                                }

                        }
                    }
                }
            }
            
            
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
            
        

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

