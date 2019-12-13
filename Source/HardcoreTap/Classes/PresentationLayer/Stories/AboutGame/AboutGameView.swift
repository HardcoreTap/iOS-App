//
//  AboutGameView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 17.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

// TODO:
struct AboutGameView: View {
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Об игре")) {
                    Text("Лови ритм! Не убивай время просто так. Убивай время с пользой. HardcoreTap  — отличная тренировка внимательности, терпеливости, чувства ритма и упорства. Поднимись на вершину рейтинга таперов. Жми на экран с интервалом в одну секунду. Важна точность до сотых. С повышением уровня игра будет к тебе всё строже. Думаешь, это так просто? Попробуй.")
                }
                Section(header: Text("Расскажите о нас")) {
                    ExampleRowView()
                    ExampleRowView()
                }
                Section(header: Text("Мы на Github")) {
                    ExampleRowView()
                    ExampleRowView()
                    ExampleRowView()
                }
            }.listStyle(GroupedListStyle())
        }.navigationBarTitle("About game")
    }
    
}

struct AboutGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutGameView()
        }
    }
}

struct ExampleRowView: View {
    var body: some View {
        Text("todo")
    }
}
