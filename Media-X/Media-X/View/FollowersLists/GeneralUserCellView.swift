//
//  GeneralUserCellView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 15/07/2025.
//

import SwiftUI

struct GeneralUserCellView:View {
    @State var width:CGFloat = 80
    let user:SBUserModel
    let action:()->Void
    let ontapAction: () -> ()
    var body: some View {
        HStack {
            if let url = URL(string: "\(Constants.SUPABASE_STORAGE_END_POINT)\(user.imageId)") {
                ImageBorderView(imageUrl: url)
                    .frame(width: width,height: width)
            }
            Text(user.name)
                .customFont(.medium, size: 20)
            
            Spacer()
            
            if let isFollower = user.isFollower {
                Button {
                    action()
                }label: {
                    Text(isFollower ? "Following": "Follow")
                        .foregroundStyle(.white)
                        .padding(.vertical,10)
                        .frame(width: 80)
                        .background(isFollower ? .gray:._3_B_9678)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.bottom)
                }
            }
        }
        .padding(.horizontal)
        .contentShape(.rect)
        .onTapGesture {
            ontapAction()
        }
    }
}
