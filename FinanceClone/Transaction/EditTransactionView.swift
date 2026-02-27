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
    let onSaveCallback: (_ txn: TransactionEntry) -> Void
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State private var entries: [CashFlowEntryWrapper] = []
    @State private var date: Date = Date()
    @State private var notes = ""
    @State private var payee = ""
    @State private var number = ""
    @State private var cleared = true
    @State private var isApplyingAutoSplitSuggestion = false

    private let balanceTolerance = 0.000001
    private let amountPrecisionScale = 100.0
    
    init(txn: TransactionEntry,
         onSaveCallback: @escaping (_ txn: TransactionEntry) -> Void = {txn in }) {
        self.txn = txn
        self.onSaveCallback = onSaveCallback
        self._date = State(initialValue: txn.date ?? Date())
        self._notes = State(initialValue: txn.note)
        self._payee = State(initialValue: txn.payee)
        self._number = State(initialValue: txn.number)
        self._cleared = State(initialValue: txn.cleared)
        
        var entries: [CashFlowEntryWrapper] = []
        if txn.entries != nil {
            for entry in txn.entries! {
                entries.append(
                    CashFlowEntryWrapper(
                        account: entry.account,
                        amount: entry.amount,
                        currency: entry.currency ?? entry.account?.currency ?? .USD
                    )
                )
            }
        }
        if entries.isEmpty {
            entries.append(CashFlowEntryWrapper(amount: 0.0))
            entries.append(CashFlowEntryWrapper(amount: 0.0))
        }
        self._entries = State(initialValue: entries)
    }
    
    var hasValidData: Bool {
        self.entries.count >= 2 &&
        self.entries.allSatisfy({$0.account != nil}) &&
        self.entries.allSatisfy({$0.amount != 0}) &&
        abs(self.entries.reduce(0, { total, newEntry in
            return total + newEntry.amount
        })) <= balanceTolerance
    }
    
    func save() {
        txn.date = self.date
        txn.note = self.notes
        txn.payee = self.payee
        txn.number = self.number
        txn.cleared = self.cleared
        if txn.journal == nil {
            txn.journal = journal
        }

        for existingEntry in txn.entries ?? [] {
            modelContext.delete(existingEntry)
        }

        txn.entries = []
        for entry in self.entries {
            let newEntry = CashFlowEntry(transactionRef: txn, account: entry.account, amount: entry.amount, currency: entry.currency)
            txn.entries!.append(newEntry)
        }

        onSaveCallback(txn)
        dismiss()
    }

    func addSplitEntry() {
        entries.append(CashFlowEntryWrapper(currency: journal.defaultCurreny))
        suggestSplitAmountsIfNeeded()
    }

    private var entrySignature: String {
        entries
            .map { entry in
                "\(entry.id)|\(entry.account?.id ?? "")|\(entry.amount)|\(entry.currency.rawValue)"
            }
            .joined(separator: ";")
    }

    private func roundedToCurrencyPrecision(_ value: Double) -> Double {
        (value * amountPrecisionScale).rounded() / amountPrecisionScale
    }

    private func suggestSplitAmountsIfNeeded() {
        if isApplyingAutoSplitSuggestion {
            return
        }

        let unfilledIndices = entries.indices.filter { idx in
            abs(entries[idx].amount) <= balanceTolerance
        }
        guard !unfilledIndices.isEmpty else { return }

        let filledTotal = entries.enumerated().reduce(0.0) { partial, item in
            unfilledIndices.contains(item.offset) ? partial : partial + item.element.amount
        }
        let balancingAmount = -filledTotal

        isApplyingAutoSplitSuggestion = true
        defer { isApplyingAutoSplitSuggestion = false }

        if unfilledIndices.count == 1, let idx = unfilledIndices.first {
            entries[idx].amount = roundedToCurrencyPrecision(balancingAmount)
            return
        }

        let eachShare = roundedToCurrencyPrecision(balancingAmount / Double(unfilledIndices.count))
        var remaining = balancingAmount
        for idx in unfilledIndices.dropLast() {
            entries[idx].amount = eachShare
            remaining -= eachShare
        }
        if let last = unfilledIndices.last {
            entries[last].amount = roundedToCurrencyPrecision(remaining)
        }
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
                                        $0.id == entry.wrappedValue.id
                                    })
                                }, label: {
                                    Text("Delete")
                                })
                                .tint(.red)
                            }
                    }
                }, footer: {
                    Button(action: {
                        addSplitEntry()
                    }, label: {
                        Label("Add Split", systemImage: "plus.circle.fill")
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
        .listStyle(.plain)
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .contentMargins(.horizontal, 0, for: .scrollIndicators)
        .multilineTextAlignment(.leading)
        .onChange(of: entrySignature, initial: true) { _, _ in
            suggestSplitAmountsIfNeeded()
        }
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

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    let txn = seedIncomeTransaction(container: previewContainer, journal: journal)
    txn.entries = []
    return EditTransactionView(txn: txn)
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
