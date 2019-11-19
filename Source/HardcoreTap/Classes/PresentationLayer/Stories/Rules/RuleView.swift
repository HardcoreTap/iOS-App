//
//  RuleView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 22.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

enum RuleType {
    case rule1
    case rule2
    case rule3
    
    var text: String {
        switch self {
        case .rule1: return "Тапай по экрану с интервалом ровно в одну секунду. Идеальная точность — 00 миллисекунд."
        case .rule2: return "С ростом уровня, тебе нужно быть всё точнее. Допустимая погрешность уменьшается и приближается к нулю. "
        case .rule3: return "Цель игры — стать лучшим ловцом ритма и возглавить TOP 10 игроков!"
        }
    }
    
    var image: String {
        switch self {
        case .rule1: return "rule1"
        case .rule2: return "rule2"
        case .rule3: return "rule3"
        }
    }
}

struct RuleView: View {
    
    @State var type: RuleType
    
    var body: some View {
        HStack {
            Image(type.image).padding()
            Text(type.text)
        }
    }
    
}
