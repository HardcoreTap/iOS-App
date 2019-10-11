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
    
    var body: some View {
        VStack {
            Image("icon")
                .padding()
            Text("Добро пожаловать!")
                .font(.title)
                .padding()
            TextField("Придумайте себе имя", text: $nickname)
                .padding()
            Button(action: {}) { Text("Начать игру") }
                .padding()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
