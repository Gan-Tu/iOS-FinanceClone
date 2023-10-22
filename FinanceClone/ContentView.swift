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
    
    var body: some View {
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
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return ContentView().modelContainer(previewContainer)
}
