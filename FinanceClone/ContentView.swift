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
    @State private var isSearchSheetPresented: Bool = false
    
    @State private var isAddTransactionPickAccountPresented: Bool = false
    @State private var isAddTransactionSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                JournalHomeView()
            }
            
            Spacer()
            
            HStack {
                if appState.currentJournal != nil {
                    Button(action: { isSearchSheetPresented = true }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.accent)
                            .font(.title2)
                    })
                } else {
                    Button(action: { isSettingsSheetPresented = true }, label: {
                        Image(systemName: "gear")
                            .foregroundColor(.accent)
                            .font(.title2)
                    })
                }
                
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
                        isAddTransactionPickAccountPresented = true
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
            .confirmationDialog(
                "You are creating a new transaction.",
                isPresented: $isAddTransactionPickAccountPresented,
                titleVisibility: .visible
            ) {
                Button {
                    isAddTransactionSheetPresented = true
                } label: {
                    Text("Expense")
                }
                
                Button {
                    isAddTransactionSheetPresented = true
                } label: {
                    Text("Income")
                }
                
                Button {
                    isAddTransactionSheetPresented = true
                } label: {
                    Text("Transfer")
                }
            }
            .sheet(isPresented: $isAddTransactionSheetPresented, content: {
                if appState.currentJournal != nil {
                    CreateTransactionView()
                        .environmentObject(appState.currentJournal!)
                }
            })
            .sheet(isPresented: $isSearchSheetPresented, content: {
                if appState.currentJournal != nil {
                    SearchTransactionView()
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
