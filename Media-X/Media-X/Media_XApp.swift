//
//  Media_XApp.swift
//  Media-X
//
//  Created by Moataz Mohamed on 16/05/2025.
//

import SwiftUI
//    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
@main
struct Media_XApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var navigationStateManager = NavigationStateManager(selectionPath: [AppNavigationPath]())
    @StateObject var globalLoading = GlobalLoading()
    @StateObject var tokenManager = TokenManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationStateManager)
                .environmentObject(globalLoading)
                .environmentObject(tokenManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @EnvironmentObject var tokenManager: TokenManager
    
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            LoadingView(isLoading: .constant(true))
                .navigationDestination(for: AppNavigationPath.self) { path in
                    switch path {
                    case .login:
                        LogInView()
                    case .register:
                        RegisterView()
                    case .tabBar:
                        Text("tabbar")
                    }
                }
                .onAppear {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
                .onReceive(tokenManager.sessionEnded) { isEnded in
                    DispatchQueue.main.async {
                        if isEnded {
                            navigationStateManager.popToStage(stage: .login)
                        } else {
                            navigationStateManager.popToStage(stage: .tabBar)
                        }
                    }
                }
        }
    }
}



class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
