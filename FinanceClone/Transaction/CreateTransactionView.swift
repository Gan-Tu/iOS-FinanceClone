//
//  CreateTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI
import SwiftData

enum TransactionTemplate: String, CaseIterable {
    case expense = "Expense"
    case income = "Income"
    case transfer = "Transfer"
}

struct CreateTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    
    let template: TransactionTemplate
    let seedNote: String
    @State private var txn: TransactionEntry
    @EnvironmentObject var journal: Journal
    
    init(template: TransactionTemplate = .transfer, seedNote: String = "") {
        self.template = template
        self.seedNote = seedNote
        self._txn = State(initialValue: TransactionEntry(date: Date(), note: seedNote, payee: "", cleared: true))
    }
    
    var body: some View {
        EditTransactionView(txn: txn, onSaveCallback: { txn in
            txn.journal = journal
            if !(journal.transactions?.contains(where: { $0.id == txn.id }) ?? false) {
                journal.transactions?.append(txn)
            }
            modelContext.insert(txn)
        })
        .navigationBarTitle("New \(template.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    return CreateTransactionView()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
