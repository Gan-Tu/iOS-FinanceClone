//
//  TransactionPreviewRow.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import SwiftUI
import SwiftData

struct TransactionPreviewRow: View {
    let entry: TransactionEntry
    @Environment(\.modelContext) private var modelContext
    
    var note: String {
        entry.note.isEmpty ? "Expense" : entry.note
    }
    
    var isIncome: Bool {
        entry.entries != nil &&
        entry.entries!.contains(where: { $0.account?.category == .income })
    }
    
    var body: some View {
        HStack {
            VStack {
                if !entry.cleared {
                    Circle().foregroundStyle(.gray)
                }
            }
            .frame(width: 15)
            
            VStack {
                HStack {
                    Text(note)
                    
                    if !entry.payee.isEmpty {
                        HStack(spacing: 0) {
                            Text("@").foregroundStyle(.secondary)
                            Text(entry.payee)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(entry.describeAmount())")
                        .foregroundStyle(isIncome ? Color.green : Color.red)
                }
                
                HStack {
                    ForEach(isIncome ? entry.debitedAcconuts : entry.creditedAcconuts, id: \.self) { acc in
                        Text(acc.name)
                            .foregroundStyle(
                                acc.label != nil ? acc.label!.color : .secondary
                            )
                    }
                    
                    Image(systemName: isIncome ? "arrow.left" : "arrow.right")
                    
                    ForEach(isIncome ? entry.creditedAcconuts : entry.debitedAcconuts, id: \.self) { acc in
                        Text(acc.name)
                            .foregroundStyle(acc.label != nil ? acc.label!.color : .secondary)
                    }
                    
                    
                    Spacer()
                    
                    Text("$balance")
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
                
            }
            .multilineTextAlignment(.leading)
            .lineLimit(1, reservesSpace: false)
            .swipeActions(edge: .leading) {
                Button(action: {
                    entry.cleared.toggle()
                }, label: {
                    Text(entry.cleared ? "Uncleared" : "Clearaed")
                })
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive, action: {
                     modelContext.delete(entry)
                }, label: {
                    Text("Delete")
                })
                .tint(.red)
                
                Button(action: {
                    // TODO
                }, label: {
                    Text("Duplicate")
                })
                .tint(.gray)
                
            }
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = Journal(name: "Test")
    journal.currencies.append(Currency.USD)
    previewContainer.mainContext.insert(journal)
    
    let checking = Account(name: "Checking", journal: journal, category: .asset)
    let salary = Account(name: "Salary", journal: journal, category: .income, label: .green)
    let credit = Account(name: "Credit Card", journal: journal, category: .liabilities)
    let utilities = Account(name: "Utilities", journal: journal, category: .expense, label: .yellow)
    
    let trans1 = addTransaction(container: previewContainer, from: salary, to: checking, amount: 5000, note: "Paycheck", payee: "Google", currency: Currency.USD)
    let trans2 = addTransaction(container: previewContainer, from: salary, to: checking, amount: 4000, note: "", payee: "Google", currency: Currency.EUR)
    trans2.cleared = false
    let trans3 = addTransaction(container: previewContainer, from: credit, to: utilities, amount: 94.2, note: "Electricity", payee: "Edison", currency: Currency.USD)
    
    return NavigationView {
        List {
            TransactionPreviewRow(entry: trans1)
                .modelContainer(previewContainer)
            
            TransactionPreviewRow(entry: trans2)
                .modelContainer(previewContainer)
            
            TransactionPreviewRow(entry: trans3)
                .modelContainer(previewContainer)
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
    }
    .padding(.horizontal, 10)
}
