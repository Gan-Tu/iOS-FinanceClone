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
    @State private var isAddTransactionSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                JournalHomeView()
            }
            
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
                
                if appState.currentJournal != nil {
                    Button(action: {
                        isAddTransactionSheetPresented = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.accent)
                            .font(.title2)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .sheet(isPresented: $isSettingsSheetPresented, content: {
                SettingsView()
            })
            .sheet(isPresented: $isCloudSyncSheetPresented, content: {
                CloudSyncView(showDoneButton: true)
            })
            .sheet(isPresented: $isAddTransactionSheetPresented, content: {
                if appState.currentJournal != nil {
                    CreateTransactionView()
                        .environmentObject(appState.currentJournal!)
                }
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
