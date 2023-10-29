//
//  CurrencyActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct CurrencyActionSheet: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State private var showChoices = false
    @State private var showAddCurrencySheet = false
    @State private var newCurrency: Currency?
    
    var body: some View {
        HStack {
            Text("CURRENCIES")
            
            Spacer()
            
            Button(action: { showChoices = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action",
                isPresented: $showChoices,
                titleVisibility: .hidden
            ) {
                Button("Add Curency") {
                    showAddCurrencySheet = true
                }
            }
            .sheet(isPresented: $showAddCurrencySheet) {
                AddCurrencySheetView() { currency in
                    if currency != nil {
                        journal.currencies.append(currency!)
                    }
                }
            }
            .textCase(nil)
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    let example = Journal(name: "Example")
    previewContainer.mainContext.insert(example)

    return CurrencyActionSheet()
        .modelContainer(previewContainer)
        .environmentObject(example)
}
