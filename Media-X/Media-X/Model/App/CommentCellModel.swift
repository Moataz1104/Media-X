//
//  CommentCellModel.swift
//  Media-X
//
//  Created by Moataz Mohamed on 02/07/2025.
//

import Foundation


struct CommentCellModel : Identifiable {
    
    let id = UUID()
    var comment:SBFetchedComment
    var children:[SBFetchedComment] = []
    
}
