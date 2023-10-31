//
//  CreateAccountView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftUI
import SwiftData

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: AccountCategory = .asset
    @State private var accountCurrency: Currency?
    @State private var label: AccountLabel?
    
    
    init(category: AccountCategory) {
        _category = State(initialValue: category)
    }
    
    var body: some View {
        NavigationStack {
            AccountMetadataForm(
                name: $name,
                description: $description,
                category: $category,
                accountCurrency: $accountCurrency,
                accountLabel: $label
            )
            .font(.body)
            .navigationBarTitle("New Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveAccount)
                        .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func saveAccount() {
        if !name.isEmpty {
            let account = Account(name: name,
                                  journal: journal,
                                  category: category,
                                  description: description)
            account.label = label
            if accountCurrency != nil {
                account.currency = accountCurrency!;
            }
            journal.accounts?.append(account)
            dismiss()
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return CreateAccountView(category: .income)
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
