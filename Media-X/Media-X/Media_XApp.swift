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
    @StateObject var globalUser = GlobalUser()
    @StateObject var uploadPostVM = UploadPostViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationStateManager)
                .environmentObject(globalLoading)
                .environmentObject(globalUser)
                .environmentObject(uploadPostVM)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager<AppNavigationPath>
    @EnvironmentObject var globalUser : GlobalUser
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            StartView(){userData in
                globalUser.user = userData
            }
            .navigationDestination(for: AppNavigationPath.self) { path in
                switch path {
                case .tabBar:
                    TabBarView()
                case .register :
                    RegisterView()
                case .userForm:
                    UserFormView()
                }
            }
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
    }
}

struct StartView:View {
    @State private var user:SBUserModel?
    @State private var isLoading = true
    @State private var requestSent = false
    @EnvironmentObject var globalUser:GlobalUser
    let userDataClosure:(SBUserModel) -> Void
    var body: some View {
        VStack{
            if isLoading{
                ProgressView()
                    .scaleEffect(2)
            }else{
                if let _ = user{
                    TabBarView()
                }else{
                    LogInView(){model in
                        userDataClosure(model)
                    }
                }
            }
        }
        
        .task {
            guard user == nil, !requestSent else{return}
            await removeKeychain()
            await user = AuthManager.shared.getUser()
            if let data = user{
                userDataClosure(data)
            }
            isLoading = false
            requestSent = true
        }
    }
    
    private func removeKeychain() async
        {
            let userDefaults = UserDefaults.standard
            if userDefaults.value(forKey: "first_open_key") == nil {
                userDefaults.setValue(true, forKey: "first_open_key")
                userDefaults.synchronize()
                do {
                    try await AuthManager.shared.signOutUser()
                }catch {
                    print(error.localizedDescription)
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
