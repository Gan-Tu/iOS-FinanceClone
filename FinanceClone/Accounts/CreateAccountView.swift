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
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: AccountCategory = .asset
    
    private var exampleCurrencies: [String] = ["US Dollar", "Euro"]
    @State private var currency: String = "US Dollar"
    
    init(category: AccountCategory) {
        _category = State(initialValue: category)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section {
                    Picker("Group In", selection: $category) {
                        ForEach(AccountCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Currency", selection: $currency) {
                        ForEach(exampleCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationBarTitle("New Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: {
                        dismiss()
                    })
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
            modelContext.insert(
                Account(name: name,
                        accountDescription: description,
                        category: category))
            dismiss()
        }
    }
}

#Preview("Asset") {
    CreateAccountView(category: .asset)
        .modelContainer(for: Account.self, inMemory: true)
}

#Preview("Income") {
    CreateAccountView(category: .income)
        .modelContainer(for: Account.self, inMemory: true)
}
