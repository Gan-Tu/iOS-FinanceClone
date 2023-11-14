//
//  ContentView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @ObservedObject var appState = AppState()
    
    @State private var isSettingsSheetPresented: Bool = false
    @State private var isCloudSyncSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            JournalHomeView()
            
            Spacer()
            
            HStack {
                Button(action: { isSettingsSheetPresented = true }, label: {
                    Image(systemName: "gear")
                        .foregroundColor(.accent)
                        .font(.title2)
                })
                
                Spacer()
                
                Button(action: { isCloudSyncSheetPresented = true }, label: {
                    if appState.isCloudSyncEnabled {
                        Text("Update to date")
                    } else {
                        Text("Sync Disabled")
                    }
                })
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .sheet(isPresented: $isSettingsSheetPresented, content: {
                SettingsView()
            })
            .sheet(isPresented: $isCloudSyncSheetPresented, content: {
                CloudSyncView(showDoneButton: true)
            })
        }
        .environmentObject(appState)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer()
    return ContentView()
        .modelContainer(previewContainer)
}
