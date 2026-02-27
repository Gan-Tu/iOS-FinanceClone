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
    @StateObject private var appState = AppState()
    @State private var mainModelContainer: ModelContainer

    init() {
        _mainModelContainer = State(initialValue: createMainModelContainer())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
                .onChange(of: appState.isCloudSyncEnabled, initial: false) { _, isEnabled in
                    appState.currentJournal = nil
                    mainModelContainer = createMainModelContainer(cloudSyncEnabled: isEnabled)
                }
        }
        .modelContainer(mainModelContainer)
    }
}
