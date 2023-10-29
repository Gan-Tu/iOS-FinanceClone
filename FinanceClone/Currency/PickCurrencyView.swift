//
//  PickCurrencyView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI

struct PickCurrencyView: View {
    // TODO(tugan): replace with journal currencies
    @Binding var selectedCurrency: Currency?
    
    @Environment(\.dismiss) var dismiss
    @State private var currencies: [Currency] = [Currency.USD]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies, id: \.self) { currency in
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
                    NavigationLink(destination: {
                        CurrencySelectorView(showCancelButton: false) { currency in
                            // TODO(tugan): update journal currency
                            currencies.append(currency)
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
}

#Preview {
    @State var selectedCurrency: Currency?
    return PickCurrencyView(selectedCurrency: $selectedCurrency)
}
