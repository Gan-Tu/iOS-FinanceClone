//
//  CreateJournalView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct CreateJournalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    
    @State private var defaultCurrency: Currency? = .USD
    
    private var exampleTemplates: [String] = ["Personal", "Business"]
    @State private var selectedTemplate: String = "Personal"
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    NavigationLink(destination: {
                        CurrencySelectorView(selectedCurrency: $defaultCurrency)
                            .navigationBarTitle("Currency")
                            .navigationBarTitleDisplayMode(.large)
                    }, label: {
                        HStack {
                            Text("Currency")
                            Spacer()
                            if defaultCurrency != nil {
                                Text(defaultCurrency!.name).foregroundStyle(.secondary)
                            }
                        }
                        
                    })
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
            let journal = Journal(name: name)
//            if selectedTemplate == "Personal" {
//                initPersonalTemplate(
//                    container: modelContext.container,
//                    journal: journal)
//            }
            // TODO(tugan): seed data based on templates
            if defaultCurrency != nil {
                journal.currencies = [defaultCurrency!]
            }
            modelContext.insert(journal)
        }
        dismiss()
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    return CreateJournalView().modelContainer(previewContainer)
}
