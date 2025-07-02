//
//  HomeViewModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation

@MainActor
class HomeViewModel :ObservableObject{
    
    
    @Published var posts : [SBFetchedPost] = []
    
    private let manager : PostsFetchingProtocol
    private var page = 0
    private var isFetching = false
    init () {
        manager = FeedsManager()
    }
    
    func resetPosts() {
        page = 0
        posts = []
        fetchPosts()
    }
    
    func fetchPosts() {
        guard let userId = manager.getUserId() else{return}
        guard !isFetching else{return}
        print("fetchPosts")
        isFetching = true
        page += 1
        
        Task {
            do {
                self.posts.append(contentsOf: try await manager.fetchPostsPagenated(userId: userId.uuidString, page: "\(page)"))
                
            }catch {
                print(error.localizedDescription)
            }
            
            isFetching = false
        }
        
    }
}
