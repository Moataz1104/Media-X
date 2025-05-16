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
    var body: some Scene {
        WindowGroup {
            NavigationStack(path:$navigationStateManager.selectionPath){
                LogInView()
                    .navigationDestination(for: AppNavigationPath.self) { path in
                    }
            }
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
            .environmentObject(navigationStateManager)
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
