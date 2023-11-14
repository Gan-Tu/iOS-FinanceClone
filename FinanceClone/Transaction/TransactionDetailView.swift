//
//  TransactionDetailView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/14/23.
//

import SwiftUI
import SwiftData

struct TransactionDetailView: View {
    let txn: TransactionEntry
    
    @State private var showClearSheet = false
    @State private var showEditView = false
    @EnvironmentObject var journal: Journal
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        List {
            ForEach((txn.entries ?? []), id: \.self) { entry in
                CashFlowEntryRow(entry: entry)
            }
            
            if txn.date != nil {
                VStack(alignment: .leading) {
                    Text("Date").font(.subheadline).foregroundStyle(.secondary)
                    Text(formatDate(date: txn.date!))
                }
            }
            
            if !txn.note.isEmpty {
                VStack(alignment: .leading) {
                    Text("Notes").font(.subheadline).foregroundStyle(.secondary)
                    Text(txn.note)
                }
            }
            
            if !txn.payee.isEmpty {
                VStack(alignment: .leading) {
                    Text("Payee").font(.subheadline).foregroundStyle(.secondary)
                    Text(txn.payee)
                }
            }
            
            if !txn.number.isEmpty {
                VStack(alignment: .leading) {
                    Text("Number").font(.subheadline).foregroundStyle(.secondary)
                    Text(txn.number)
                }
            }
            
            if !txn.cleared {
                Button(action: {
                    showClearSheet = true
                }, label: {
                    Text("Uncleared").foregroundStyle(.blue)
                })
            }
        }
        .listStyle(.plain)
        .multilineTextAlignment(.leading)
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showEditView.toggle() }, label: { Text("Edit")})
            }
        }
        .confirmationDialog("Mark as Cleared?", isPresented: $showClearSheet, titleVisibility: .hidden) {
            Button("Mark as Cleared") {
                txn.cleared = true
            }
        }
        .sheet(isPresented: $showEditView) {
            EditTransactionView(txn: txn)
                .environmentObject(journal)
        }
    }
}


struct CashFlowEntryRow: View {
    let entry: CashFlowEntry
    
    var body: some View {
        HStack {
            Image(systemName: entry.amount > 0 ?  "arrow.right.circle.fill" : "arrow.left.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(
                    entry.account?.label != nil ? entry.account!.label!.color : .secondary
                )
            
            HStack(spacing: 0) {
                Text(entry.account!.category.rawValue)
                    .foregroundStyle(.secondary)
                Text(":")
                Text(entry.account!.name)
                    .foregroundStyle(.primary)
            }
            .multilineTextAlignment(.leading)
            .lineLimit(2, reservesSpace: false)
            
            Spacer()
            
            Text("\(entry.describeAmount())").foregroundStyle(.secondary)
        }
        .fontWeight(.regular)
    }
}


#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    let txn = seedIncomeTransaction(container: previewContainer, journal: journal)
    return NavigationView {
        TransactionDetailView(txn: txn)
            .modelContainer(previewContainer)
            .environmentObject(journal)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    let txn = seedExpenseTransaction(container: previewContainer, journal: journal)
    return NavigationView {
        TransactionDetailView(txn: txn)
            .modelContainer(previewContainer)
            .environmentObject(journal)
    }
}
