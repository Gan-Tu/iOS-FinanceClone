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
                    Picker(selection: $category, content: {
                        ForEach(AccountCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }, label: {
                        Text("Group In")
                            .foregroundStyle(Color.primary)
                    })
                    .pickerStyle(.navigationLink)
                    
                    NavigationLink(destination: {
                        PickCurrencyView(selectedCurrency: $accountCurrency)
                    }, label: {
                        HStack {
                            Text("Currency")
                                .foregroundStyle(Color.primary)

                            Spacer()

                            if accountCurrency != nil {
                                Text(accountCurrency!.name)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    })
                }
            }
            .font(.body)
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
                                  journal: journal,
                                  category: category,
                                  description: description)
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
