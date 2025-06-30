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
    @Binding var showAddPostSheet:Bool
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            SelectPhotoView()
                .navigationDestination(for: AddPostNavigationPath.self) { path in
                    switch path {
                    case .addCaption :
                        AddCaptionView(showAddPostSheet:$showAddPostSheet)
                    }
                }
        }
        .environmentObject(navigationStateManager)
        .environmentObject(viewModel)
        
    }
}
