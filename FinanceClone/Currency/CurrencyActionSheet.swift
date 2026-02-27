//
//  CurrencyActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct CurrencyActionSheet: View {
    @EnvironmentObject var journal: Journal
    
    @State private var showChoices = false
    @State private var showAddCurrencySheet = false
    var body: some View {
        HStack {
            Text("CURRENCIES")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button(action: { showChoices = true }) {
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
            .confirmationDialog(
                "Select a action",
                isPresented: $showChoices,
                titleVisibility: .hidden
            ) {
                Button("Add Currency") {
                    showAddCurrencySheet = true
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
}

private struct CurrencyActionSheetPreview: View {
    private let previewContainer: ModelContainer
    private let example: Journal

    init() {
        let container = createPreviewModelContainer(seedData: false)
        let journal = Journal(name: "Example")
        container.mainContext.insert(journal)
        self.previewContainer = container
        self.example = journal
    }

    var body: some View {
        CurrencyActionSheet()
            .modelContainer(previewContainer)
            .environmentObject(example)
    }
}

#Preview {
    CurrencyActionSheetPreview()
}
