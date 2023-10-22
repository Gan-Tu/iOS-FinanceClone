//
//  ContentView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var journals: [Journal]
    @Query private var accounts: [Account]
    
    @State private var isSettingsSheetPresented: Bool = false
    @State private var isCloudSyncSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            JournalHomeView()
                .onAppear {
                    if journals.isEmpty {
                        // For test only
                        modelContext.insert(Journal(name: "Journal 1", numTransactions: 5))
                        modelContext.insert(Journal(name: "Journal 2", numTransactions: 10))
                    }
                    if accounts.isEmpty {
                        // For test only
                        modelContext.insert(Account(name: "Account 1"))
                        modelContext.insert(Account(name: "Account 2"))
                        modelContext.insert(Account(name: "Account 3"))
                    }
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
                    Text("Update to date")
                })
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .sheet(isPresented: $isSettingsSheetPresented, content: { SettingsView() })
            .sheet(isPresented: $isCloudSyncSheetPresented, content: { CloudSyncView(showDoneButton: true) })
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return ContentView().modelContainer(previewContainer)
}
