//
//  LoginView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 09.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var nickname: String = ""
    @State var didTapStartButton = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("icon")
                    .padding()
                Text("Welcome!")
                    .font(.title)
                    .padding()
                TextField("Придумайте себе имя", text: $nickname)
                    .padding()
                Button(action: {
                    self.didTapStartButton = true
                }) { Text("Start game") }
                    .foregroundColor(.red)
                    .padding()
            }
            .sheet(isPresented: $didTapStartButton) {
                BaseTabView()
            }
        }.navigationBarTitle("HardcoreTap")
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .environment(\.colorScheme, .dark)
            LoginView()
                .environment(\.colorScheme, .light)
        }
    }
}
