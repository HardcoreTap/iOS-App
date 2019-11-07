//
//  GameView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 07.11.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct GameView: View {
    
//    let startGameText: LocalizedStringKey = "start.game"

    var body: some View {
        NavigationView {
            VStack {
                Image("star.fill")
                Button(action: {
                    // TOOD:
                }) { Text("start.game") }
                    .foregroundColor(.red)
                    .padding()
            }
        }.navigationBarTitle("Game")
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView()
                .environment(\.colorScheme, .dark)
            GameView()
                .environment(\.colorScheme, .light)
        }
    }
}
