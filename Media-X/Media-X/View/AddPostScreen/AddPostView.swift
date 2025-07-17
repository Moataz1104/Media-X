//
//  AddPostView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 30/06/2025.
//

import SwiftUI

struct AddPostView: View {
    @StateObject var navigationStateManager = NavigationStateManager(selectionPath: [AddPostNavigationPath]())
    @StateObject private var viewModel = AddPostViewModel()
    @EnvironmentObject var uploadViewModel:UploadPostViewModel
    @Binding var showAddPostSheet:Bool
    let type : UploadType
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            SelectPhotoView()
                .navigationDestination(for: AddPostNavigationPath.self) { path in
                    switch path {
                    case .addCaption :
                        AddCaptionView(showAddPostSheet:$showAddPostSheet)
                    }
                }
                .onAppear {
                    viewModel.uploadType = type
                    uploadViewModel.uploadType = type
                }
        }
        .environmentObject(navigationStateManager)
        .environmentObject(viewModel)
        
    }
}
