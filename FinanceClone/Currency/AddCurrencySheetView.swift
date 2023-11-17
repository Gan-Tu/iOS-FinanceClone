//
//  AddCurrencySheetView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI

struct AddCurrencySheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newCurrency: Currency?
    
    let callback: (Currency?) -> Void

    var body: some View {
        NavigationStack {
            CurrencySelectorView(selectedCurrency: $newCurrency)
                .navigationBarTitle("Currencies")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: { dismiss() } )
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save", action: {
                            callback(newCurrency)
                            dismiss()
                        })
                    }
                }
        }
    }
}

#Preview {
    AddCurrencySheetView { currency in
        if currency != nil {
            print(currency!.name)
        }
    }
}
