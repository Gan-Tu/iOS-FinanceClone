//
//  CreateTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI
import SwiftData

struct CreateTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var txn: TransactionEntry
    
    init() {
        // TODO(tugan): use different initial accounts for new entry template
        let newEntry = TransactionEntry(date: Date(), note: "", payee: "", cleared: true)
        self._txn = State(initialValue: newEntry)
    }
    
    var body: some View {
        NavigationStack {
            EditTransactionView(txn: txn) { txn in
                modelContext.insert(txn)
            }
            .navigationBarTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    return CreateTransactionView()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
