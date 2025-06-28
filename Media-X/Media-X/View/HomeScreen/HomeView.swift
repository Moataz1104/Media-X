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
                    
                    VStack {
                        
                        VStack(alignment:.leading) {
                            HStack {
                                ImageBorderView()
                                    .frame(width: 55)
                                VStack(alignment:.leading) {
                                    Text("Moataz Mohamed")
                                        .customFont(.medium, size: 15)
                                    
                                    Text("16m")
                                        .customFont(.regular, size: 12)
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Image(.me)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                         
                            
                            HStack(spacing:20) {
                                PostInteractionButton(icon: "heart", count: "300") {
                                    
                                }
                                
                                PostInteractionButton(icon: "bubble", count: "300") {
                                    
                                }
                                
                                PostInteractionButton(icon: "square.and.arrow.up", count: "30") {
                                    
                                }
                                
                                Spacer()
                                PostInteractionButton(icon: "bookmark", count: "") {
                                    
                                }
                                
                            }
                            
                            Text("This is the post content")
                                .customFont(.regular, size: 18)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .padding(.vertical,10)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    }
                    .padding()
                    
                }
            }
            
            
        }
    }
}

#Preview {
    HomeView()
}







