//
//  AccountTransactionsView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import SwiftUI
import SwiftData

struct AccountTransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    
    let account: Account
    
    var body: some View {
        List {
            ForEach(account.cash_flow_entries ?? [], id: \.self) { entry in
                if entry.transactionRef != nil {
                    ZStack {
                        NavigationLink(destination: TransactionDetailView(txn: entry.transactionRef!), label: {
                            EmptyView()
                        })
                        .opacity(0)

                        TransactionPreviewRow(entry: entry.transactionRef!)
                            .listRowSeparator(.hidden, edges: .all)
                    }
                    
                }
            }
        }
        .listStyle(.plain)
        
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationView {
        VStack {
            ForEach(journal.accounts ?? [], id: \.self) { account in
                AccountTransactionsView(account: account)
            }
        }
    }
    .modelContainer(previewContainer)
    .environmentObject(journal)
}
