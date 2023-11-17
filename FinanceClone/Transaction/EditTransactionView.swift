//
//  EditTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/14/23.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    let txn: TransactionEntry
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State private var entries: [CashFlowEntryWrapper] = []
    @State private var date: Date = Date()
    @State private var notes = ""
    @State private var payee = ""
    @State private var number = ""
    @State private var cleared = true
    
    @State private var account: Account? = nil
    
    //    @State private var amount = 0.0
    
    init(txn: TransactionEntry) {
        self.txn = txn
        self._date = State(initialValue: txn.date ?? Date())
        self._notes = State(initialValue: txn.note)
        self._payee = State(initialValue: txn.payee)
        self._number = State(initialValue: txn.number)
        self._cleared = State(initialValue: txn.cleared)
        
        var entries: [CashFlowEntryWrapper] = []
        if txn.entries != nil {
            for entry in txn.entries! {
                entries.append(CashFlowEntryWrapper(account: entry.account, amount: entry.amount, currency: entry.currency ?? journal.defaultCurreny))
            }
        }
        if entries.isEmpty {
            entries.append(CashFlowEntryWrapper())
            entries.append(CashFlowEntryWrapper())
        }
        self._entries = State(initialValue: entries)
    }
    
    var hasValidData: Bool {
        self.entries.count >= 2 && self.entries.allSatisfy({$0.amount != 0})
    }
    
    func save() {
        txn.date = self.date
        txn.note = self.notes
        txn.payee = self.payee
        txn.number = self.number
        txn.cleared = self.cleared
        txn.entries?.removeAll()
        for entry in self.entries {
            let newEntry = CashFlowEntry(transactionRef: txn, account: entry.account, amount: entry.amount, currency: entry.currency)
            txn.entries!.append(newEntry)
        }
        dismiss()
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Cash Flow Section
                
                Section(content: {
                    ForEach($entries, id: \.id) { entry in
                        TransactionCashFlowEntryRow(account: entry.account, amount: entry.amount, currency: entry.currency)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive, action: {
                                    self.entries.removeAll(where: {
                                        $0 == entry.wrappedValue
                                    })
                                }, label: {
                                    Text("Delete")
                                })
                                .tint(.red)
                            }
                    }
                }, footer: {
                    Button(action: {
                        self.entries.append(CashFlowEntryWrapper())
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.multicolor)
                            .shadow(radius: 2)
                            .padding(.vertical, 2)
                    })
                })
                
                // MARK: - Details Section
                Section {
                    DatePicker("Date", selection: $date)
                    
                    VStack(alignment: .leading) {
                        if !notes.isEmpty {
                            Text("Notes").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Notes", text: $notes)
                    }
                    
                    VStack(alignment: .leading) {
                        if !payee.isEmpty{
                            Text("Payee").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Payee", text: $payee)
                    }
                    
                    VStack(alignment: .leading) {
                        if !number.isEmpty{
                            Text("Number").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Number", text: $number)
                    }
                }
                
                // MARK: - Toggles Section
                Section {
                    Toggle(isOn: $cleared, label: { Text("Cleared") })
                }
                
                // MARK: - Attachments
                Section {
                    Button(action: {
                        // TODO
                    }, label: {
                        Text("Add Attachment")
                            .foregroundStyle(.blue)
                    })
                }
            }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: {
                        save()
                    })
                    .disabled(!hasValidData)
                }
            }
        }
        .listStyle(.insetGrouped)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    let txn = seedIncomeTransaction(container: previewContainer, journal: journal)
    txn.cleared = false
    return EditTransactionView(txn: txn)
        .modelContainer(previewContainer)
        .environmentObject(journal)
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    let txn = seedExpenseTransaction(container: previewContainer, journal: journal)
    return EditTransactionView(txn: txn)
        .modelContainer(previewContainer)
        .environmentObject(journal)
}

