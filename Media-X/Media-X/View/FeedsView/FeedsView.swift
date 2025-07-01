//
//  FeedsView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 01/07/2025.
//

import SwiftUI




struct FeedsView: View {
    let posts:[SBFetchedPost]
    var body: some View {
        ForEach(posts,id:\.postData.id) { post in
            PostCellView(post: post)
        }
    }
}


