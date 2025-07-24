//
//  StorySheetView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 20/07/2025.
//

import SwiftUI

struct StorySheetView:View {
    @StateObject var navigationStateManager = NavigationStateManager(selectionPath: [StoryNavigationPath]())
    @State var isMyStory:Bool = false
    let models: [SBStoryDetails]
    let action:()->()
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            StoryView(model: models,isMyStory:isMyStory, action: action)
                .navigationDestination(for: StoryNavigationPath.self) { path in
                    switch path {
                    case .profileView(let id) :
                        ProfileView(userId: id)
                    }
                }
                .environmentObject(navigationStateManager)
        }
    }
}
