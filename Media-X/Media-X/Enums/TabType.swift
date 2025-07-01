//
//  TabType.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import Foundation
import SwiftUI
enum TabType: String, CaseIterable {
    case photos = "Photos"
    case bookmark = "Bookmarks"
    
    var icon: ImageResource {
        switch self {
        case .photos:
                .gridIcon
        case .bookmark:
                .bookmarkIcon
        }
    }
}
