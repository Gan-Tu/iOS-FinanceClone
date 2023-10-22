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
    
    private var exampleCurrencies: [String] = ["US Dollar", "Euro"]
    @State private var selectedCurrency: String = "US Dollar"
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section {
                    Picker("Currency", selection: $selectedCurrency) {
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
            modelContext.insert(Account(name: name, accountDescription: description))
            dismiss()
        }
    }
}

#Preview {
    CreateAccountView()
        .modelContainer(for: Account.self, inMemory: true)
}
