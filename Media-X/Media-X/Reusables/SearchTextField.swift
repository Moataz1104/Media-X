//
//  SearchTextField.swift
//  Media-X
//
//  Created by Moataz Mohamed on 03/07/2025.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text:String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .customFont(.medium, size: 15)
                .foregroundStyle(.gray)
            TextField("Search...", text: $text)
            
        }
        .padding(.vertical,10)
        .padding(.horizontal)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)

    }
}
