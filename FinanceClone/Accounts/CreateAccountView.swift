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
    @State private var accountCurrency: Currency?
    
    
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
                    
                    NavigationLink(destination: {
                        PickCurrencyView(selectedCurrency: $accountCurrency)
                    }, label: {
                        HStack {
                            Text("Currency")
                            Spacer()
                            if accountCurrency != nil {
                                Text(accountCurrency!.name)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    })
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
            let account = Account(name: name,
                                  accountDescription: description,
                                  category: category);
            account.currency = accountCurrency;
            modelContext.insert(account)
            dismiss()
        }
    }
}

#Preview("Asset") {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    let example = Journal(name: "Example")
    previewContainer.mainContext.insert(example)
    
    return CreateAccountView(category: .asset)
        .modelContainer(for: Account.self, inMemory: true)
        .environmentObject(example)
}

#Preview("Income") {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    let example = Journal(name: "Example")
    previewContainer.mainContext.insert(example)
    
    return CreateAccountView(category: .income)
        .modelContainer(for: Account.self, inMemory: true)
        .environmentObject(example)
}
