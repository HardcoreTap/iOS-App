//
//  RulesView.swift
//  HardcoreTap
//
//  Created by Быстрицкий Богдан on 16.10.2019.
//  Copyright © 2019 Bogdan Bystritskiy. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                RuleView(type: .rule1)
                RuleView(type: .rule2)
                RuleView(type: .rule3)
            }.padding()
        }.navigationBarTitle("Rules")
    }
    
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RulesView()
                .environment(\.colorScheme, .dark)
            RulesView()
                .environment(\.colorScheme, .light)
        }
    }
}
