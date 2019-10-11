//
//  TabView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 11.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI
//
//struct TabView : View {
//
//    var body: some View {
//        TabbedView() {
//            InboxList()
//                .tag(1)
//
//            PostsList()
//                .tag(2)
//
//            Spacer()
//                .tag(3)
//        }
//    }
//}

struct AppTabbedView: View {

    @State private var selection = 3

    init() {
        UITabBar.appearance().backgroundColor = UIColor.blue
    }
    
    var body: some View {
        TabView (selection:$selection){
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
            }
            .tag(1)
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
            }.tag(2)
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
            }.tag(3)
        }
        .font(.headline)
    }
}
