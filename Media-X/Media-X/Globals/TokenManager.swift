//
//  TokenManager.swift
//  Media-X
//
//  Created by Moataz Mohamed on 17/05/2025.
//

import Foundation
import Combine
import SwiftKeychainWrapper
import UIKit

class TokenManager : ObservableObject {
    
    let sessionEnded = PassthroughSubject<Bool, Never> ()
    private var sessionTimer: Timer?
    private let sessionDuration: TimeInterval = 24 * 60 * 59
    
    init() {
        DispatchQueue.main.async {[weak self] in
            self?.checkSessionStatus()
        }
    }
    deinit {
        sessionTimer?.invalidate()
    }
    private func checkSessionStatus() {
        sessionTimer?.invalidate()
        
        guard let loginTimestamp = UserDefaults.standard.object(forKey: Constants.LOG_IN_TIME_STAMP) as? Date else {
            sessionEnded.send(true)
            return
        }
        
        let timeElapsed = Date().timeIntervalSince(loginTimestamp)
        
        if timeElapsed > sessionDuration {
            // Session expired
            invalidateSession()
            sessionEnded.send(true)
        } else {
            // Session still valid
            sessionEnded.send(false)
            
            // Schedule timer for remaining time
            let remainingTime = sessionDuration - timeElapsed
            sessionTimer = Timer.scheduledTimer(
                withTimeInterval: remainingTime,
                repeats: false
            ) { [weak self] _ in
                self?.sessionEnded.send(true)
                self?.invalidateSession()
            }
            
            // Ensure timer fires when app enters foreground
//            setupBackgroundNotificationHandling()
        }
    }

    
    private func invalidateSession() {
        UserDefaults.standard.removeObject(forKey: Constants.LOG_IN_TIME_STAMP)
        KeychainWrapper.standard.removeObject(forKey: Constants.TOKEN)
        sessionTimer?.invalidate()
        sessionTimer = nil
    }

//    private func setupBackgroundNotificationHandling() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appWillEnterForeground),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil
//        )
//    }
//    
//    @objc private func appWillEnterForeground() {
//        // Re-check session status when app comes back to foreground
//        checkSessionStatus()
//    }

}
