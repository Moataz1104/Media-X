//
//  HomeView.swift
//  Media-X
//
//  Created by Moataz Mohamed on 27/06/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            BackGroundColorView()
            
            VStack(alignment:.leading,spacing:0) {
                Text("Media X")
                    .customFont(.bold, size: 30)
                    .foregroundStyle(._3_B_9678)
                    .padding([.horizontal, .top])
                
                ScrollView(showsIndicators:false) {
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20) {
                            ForEach(0..<20){_ in
                                StoryCellView()
                            }
                                
                        }
                        .padding()
                    }
                    
//                    FeedsView()
//                    .padding()
                    
                }
            }
            
            
        }
    }
}

#Preview {
    HomeView()
}







