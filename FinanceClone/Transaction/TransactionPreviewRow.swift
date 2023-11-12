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
    
    var note: String {
        entry.note.isEmpty ? "Expense" : entry.note
    }
    
    var isIncome: Bool {
        entry.entries != nil &&
        entry.entries!.contains(where: { $0.account?.category == .income })
    }
    
    var remainingBalance: Double {
        if entry.entries != nil {
            for cashFlowEntry in entry.entries! {
                if cashFlowEntry.account?.category == .asset  {
                    return cashFlowEntry.account!.balanceUntil(date: entry.date!)
                }
            }
            for cashFlowEntry in entry.entries! {
                if cashFlowEntry.account?.category == .liabilities  {
                    return cashFlowEntry.account!.balanceUntil(date: entry.date!)
                }
            }
        }
        return 0.0
    }
    
    var cashFlowDesc: String {
        let from = entry.creditedAcconuts.map({ $0.name }).joined(separator: ", ")
        let to = entry.debitedAcconuts.map({ $0.name }).joined(separator: ", ")
        if isIncome {
            return "\(from) -> \(to)"
        } else {
            return "\(from) -> \(to)"
        }
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
                    HStack {
                        if isIncome {
                            ForEach(entry.debitedAcconuts, id: \.self) { acc in
                                Text(acc.name)
                                    .foregroundStyle(
                                        acc.label != nil ? acc.label!.color : .secondary
                                    )
                            }
                            
                            Image(systemName: "arrow.left")
                            
                            ForEach(entry.creditedAcconuts, id: \.self) { acc in
                                Text(acc.name)
                                    .foregroundStyle(acc.label != nil ? acc.label!.color : .secondary )
                            }
                        } else {
                            ForEach(entry.creditedAcconuts, id: \.self) { acc in
                                Text(acc.name)
                                    .foregroundStyle(
                                        acc.label != nil ? acc.label!.color : .secondary
                                    )
                            }
                            
                            Image(systemName: "arrow.right")
                            
                            ForEach(entry.debitedAcconuts, id: \.self) { acc in
                                Text(acc.name)
                                    .foregroundStyle(acc.label != nil ? acc.label!.color : .secondary )
                            }
                        }
                    }
                    
                    Spacer()
                    
//                    Text("\(entry.currencySymbol)\(String(format: "%.2f", remainingBalance))")
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
                
            }
            .multilineTextAlignment(.leading)
            .lineLimit(1, reservesSpace: false)
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
    
    return VStack(spacing: 15) {
        TransactionPreviewRow(entry: trans1)
            .modelContainer(previewContainer)
        
        TransactionPreviewRow(entry: trans2)
            .modelContainer(previewContainer)
        
        TransactionPreviewRow(entry: trans3)
            .modelContainer(previewContainer)
    }
    .padding(.horizontal, 10)
}
