//
//  JournalDetailView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct JournalDetailView: View {
    var journal: Journal
    
    @State private var exampleTransactions: [String] = ["Transaction 1", "Transaction 2"]
    @State private var exampleAccounts: [String] = ["Assets", "Liabilities", "Income", "Expenses", "Equity"]
    @State private var exampleCurrencies: [String] = ["US Dollars", "Euro"]
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        List {
            Section(header: Text("Transactions".uppercased())) {
                ForEach(exampleTransactions, id: \.self) { transaction in
                    NavigationLink(destination: TransactionPageView(title: transaction), label: {
                        Text(transaction)
                    })
                }
                .onDelete(perform: { offsets in
                    // TODO
                })
            }
            
            Section(header: Text("Accounts".uppercased())) {
                ForEach(exampleAccounts, id: \.self) { account in
                    NavigationLink(destination: TransactionPageView(title: account), label: {
                        Text(account)
                    })
                }
                .onDelete(perform: { offsets in
                    // TODO
                })
            }
            
            Section(header: Text("Currencies".uppercased())) {
                ForEach(exampleCurrencies, id: \.self) { currency in
                    NavigationLink(destination: TransactionPageView(title: currency), label: {
                        Text(currency)
                    })
                }
                .onDelete(perform: { offsets in
                    // TODO
                })
            }
        }
        .navigationTitle(journal.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
    }
}

#Preview {
    let example = Journal(name: "Example")
    return NavigationView {
        JournalDetailView(journal: example)
            .modelContainer(for: Journal.self, inMemory: true)
    }
}
