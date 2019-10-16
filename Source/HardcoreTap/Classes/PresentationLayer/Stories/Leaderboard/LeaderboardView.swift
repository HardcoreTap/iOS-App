//
//  LeaderboardView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 16.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct LeaderboardView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                List(0..<10) { item in
                    HStack {
                        Image("star.fill")
                            .padding()
                        Text("nickname \(item)")
                    }
                }
            }
        }.navigationBarTitle("Leaderboard")
    }
    
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeaderboardView()
                .environment(\.colorScheme, .dark)
            LeaderboardView()
                .environment(\.colorScheme, .light)
        }
    }
}
