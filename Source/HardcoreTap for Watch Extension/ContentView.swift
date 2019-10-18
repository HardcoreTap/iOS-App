//
//  ContentView.swift
//  HardcoreTap for TV
//
//  Created by Быстрицкий Богдан on 18.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var nickname: String = ""
    @State var didTapStartButton = false
    
    var body: some View {
            VStack {
                Image("icon")
                    .padding()
                Text("Добро пожаловать!")
                    .font(.title)
                    .padding()
                TextField("Придумайте себе имя", text: $nickname)
                    .padding()
                Button(action: {
                    self.didTapStartButton = true
                }) { Text("Начать игру") }
                    .foregroundColor(.red)
                    .padding()
            }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .dark)
            ContentView()
                .environment(\.colorScheme, .light)
        }
    }
}
