//
//  NotificationViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import Foundation

class NotificationViewModel : ObservableObject {
 
    
    private let manager: NotificationManagerProtocol
    private var notificationsDataSource : [SBNotification] = [] {
        didSet {
            self.handleNewTab()
        }
    }
    @Published var notifications : [SBNotification] = []
    @Published var isLoading = false
    @Published var selectedTab : NotificationTabType = .all
    
    
    init() {
        manager = NotificationManager()
        fetchNotifications()
    }
    
    
    
    
    func fetchNotifications() {
        guard let userId = manager.getUserId() else { return }
        isLoading = true
        Task {
            do {
                let result = try await manager.fetchNotifications(userId: userId.uuidString)
                
                await MainActor.run {
                    self.notificationsDataSource = result
                }
                
            }catch {
                print(error.localizedDescription)
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    func updateAllNotificationsToRead() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                for model in self.notifications {
                    group.addTask {
                        await self.updateNotificationToRead(model: model)
                    }
                }
            }
        }
    }
    @MainActor
    func updateNotificationToRead(model:SBNotification)async {
        guard !model.watched else { return }
        var tempModel = model
        tempModel.watched = true
        tempModel.imageId = nil
        tempModel.username = nil
        
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(where: {$0.id == tempModel.id}) {
                self.notifications[index].watched = true
            }
        }
        
        do {
            
            let result = try await manager.updateNotification(model: tempModel)
            switch result {
            case .success(_):
                print("updateNotification success")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    
    func handleNewTab() {
        switch self.selectedTab {
        case .all :
            self.notifications = notificationsDataSource
        case .New :
            self.notifications = notificationsDataSource.filter({!$0.watched})
        case .watched :
            self.notifications = notificationsDataSource.filter({ $0.watched})
        }
    }
}
