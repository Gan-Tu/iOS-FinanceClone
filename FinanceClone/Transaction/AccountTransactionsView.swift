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
        VStack(spacing: 10) {
            ForEach(account.cash_flow_entries ?? [], id: \.self) { entry in
                if entry.transactionRef != nil {
                    TransactionPreviewRow(entry: entry.transactionRef!)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return VStack(spacing: 5) {
        Spacer()
        ForEach(journal.accounts ?? [], id: \.self) { account in
            if account.category == .asset ||
                account.category == .liabilities {
                AccountTransactionsView(account: account)
            }
        }
        Spacer()
    }
    .modelContainer(previewContainer)
}
