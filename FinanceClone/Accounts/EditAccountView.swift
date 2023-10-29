//
//  EditAccountView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI
import SwiftData


struct EditAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let account: Account
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: AccountCategory = .asset
    @State private var accountCurrency: Currency?
    
    init(account: Account) {
        self.account = account
        _name = State(initialValue: account.name)
        _description = State(initialValue: account.accountDescription)
        _category = State(initialValue: account.category)
        _accountCurrency = State(initialValue: account.currency)
    }

    var body: some View {
        NavigationStack {
            AccountMetadataForm(
                name: $name,
                description: $description,
                category: $category,
                accountCurrency: $accountCurrency)
            .font(.body)
            .navigationBarTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: updateAccount)
                        .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func updateAccount() {
        if !name.isEmpty {
            account.name = name
            account.accountDescription = description
            account.category = category
            if accountCurrency != nil {
                account.currency = accountCurrency ?? Currency.USD
            }
            dismiss()
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return EditAccountView(account: journal.accounts![0])
        .modelContainer(previewContainer)
        .environmentObject(journal)
}

