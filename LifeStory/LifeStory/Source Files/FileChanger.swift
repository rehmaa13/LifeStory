//
//  FileChanger.swift
//  LifeStory
//
//  Created by Adil Rehman on 20/04/2021.
//

import Foundation
import SwiftUI

struct fileChanger: View {
    
    @State var selection: Int = 0
    
    var body: some View {
    // Your native TabView here
    TabView(selection: $selection) {
        Tutorial()
            .tag(0)
        
        StoryList()
            .tag(1)
        
        VaultView()
            .tag(2)
        
    }
    .overlay( // Overlay the custom TabView component here
        Color.white // Base color for Tab Bar
            .edgesIgnoringSafeArea(.vertical)
            .frame(height: 50) // Match Height of native bar
            .overlay(HStack {
                Spacer()
                
                // First Tab Button
                Button(action: {
                    self.selection = 0
                }, label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                        .opacity(selection == 0 ? 1 : 0.4)
                })
                Spacer()
                
                // Second Tab Button
                Button(action: {
                    self.selection = 1
                }, label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                        .opacity(selection == 1 ? 1 : 0.4)
                })
                
                Spacer()
                
                Button(action: {
                    self.selection = 2
                  
                }, label: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                        .opacity(selection == 2 ? 1 : 0.4)
                })
                
                Spacer()
                
            })
    ,alignment: .bottom) // Align the overlay to bottom to ensure tab bar stays pinned.

    }
}
