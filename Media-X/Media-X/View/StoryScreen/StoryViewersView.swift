//
//  StoryViewersView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 20/07/2025.
//

import SwiftUI

struct StoryViewersView:View {
    @EnvironmentObject var viewModel:StoryDetailsViewModel
    @State private var users:[SBUserModel]?
    let imageId:UUID
    let onTapAction:(UUID)->()
    var body: some View {
        VStack {
            Text("Views")
                .customFont(.bold, size: 25)
                .foregroundStyle(.black)
                .padding([.top,.horizontal])
            Spacer()
            if let users = users {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(users) { user in
                            GeneralUserCellView(width:50,user: user) {} ontapAction: {
                                onTapAction(user.id)
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(.horizontal,30)
                        }
                    }
                    .padding(.top)
                }
            }
            
        }
        .task {
            do {
                self.users = try await viewModel.getViewers(imageId: self.imageId)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
