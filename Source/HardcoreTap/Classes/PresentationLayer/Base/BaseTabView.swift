//
//  TabView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 11.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct BaseTabView: View {
    
    @State private var selection = 1
    
    var body: some View {
        TabView (selection: $selection) {
            GameView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Game")
            }
            .tag(1)
            LeaderboardView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Leaderboard")
            }.tag(2)
            RulesView()
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("Rules")
            }.tag(3)
            AboutGameView()
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("About game")
            }.tag(4)
        }
        .font(.headline)
    }
}
