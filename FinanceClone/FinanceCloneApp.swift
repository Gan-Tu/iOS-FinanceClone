//
//  FinanceCloneApp.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

@main
struct FinanceCloneApp: App {
    var mainModelContainer: ModelContainer = createMainModelContainer();
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(mainModelContainer)
    }
}
