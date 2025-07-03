//
//  NavigationStateManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import Foundation
import Foundation

@MainActor
class NavigationStateManager<NavigationStage: Hashable>: ObservableObject {
    @Published var selectionPath: [NavigationStage]
    
    init(selectionPath: [NavigationStage] = []) {
        self.selectionPath = selectionPath
    }
    
    func pushToStage(stage: NavigationStage) {
        selectionPath.append(stage)
    }
    
    func popToStage(stage: NavigationStage) {
        selectionPath = [stage]
    }
    func popToRoot() {
        selectionPath = []
    }
}

enum AppNavigationPath: Hashable {
    case tabBar
    case register
    case userForm
    case profileView(id:String)
}


enum AddPostNavigationPath: Hashable {
    case addCaption
    
}


