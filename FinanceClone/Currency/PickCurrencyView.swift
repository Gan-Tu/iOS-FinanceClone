//
//  PickCurrencyView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI
import SwiftData

struct PickCurrencyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var journal: Journal
    
    @Binding var selectedCurrency: Currency?
    @State private var showAddCurrencySheet = false
    
    var body: some View {
        List {
            ForEach(journal.currencies, id: \.self) { currency in
                CurrencyItem(currency: currency, isSelected: false)
                    .onTapGesture(perform: {
                        selectedCurrency = currency;
                        dismiss();
                    })
            }
        }
        .navigationBarTitle("Currencies")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddCurrencySheet = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showAddCurrencySheet) {
            AddCurrencySheetView { currency in
                if currency != nil {
                    journal.currencies.append(currency!)
                }
            }
        }
    }
}

#Preview {
    @State var selectedCurrency: Currency?
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false);
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationStack {
        PickCurrencyView(selectedCurrency: $selectedCurrency)
            .modelContainer(previewContainer)
        .environmentObject(journal)
    }
}
