//
//  AddJournalSheetView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct AddJournalSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    
    // TODO(tugan): fetch this from journal's currency
    private var exampleCurrencies: [String] = ["US Dollar", "Euro"]
    @State private var selectedCurrency: String = "US Dollar"
    
    private var exampleTemplates: [String] = ["Personal", "Business"]
    @State private var selectedTemplate: String = "Personal"
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(exampleCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(header: Text("TEMPLATES")) {
                    Picker("Template", selection: $selectedTemplate) {
                        ForEach(exampleTemplates, id: \.self) { tmpl in
                            Text(tmpl).tag(tmpl)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }
            .navigationBarTitle("New Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: {
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveJournal)
                        .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func saveJournal() {
        if !name.isEmpty {
            modelContext.insert(Journal(name: name))
            dismiss()
        }
    }
}

#Preview {
    AddJournalSheetView()
        .modelContainer(for: Journal.self, inMemory: true)
}
