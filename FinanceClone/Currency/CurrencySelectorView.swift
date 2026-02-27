//
//  CurrencySelectorView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI

struct CurrencySelectorView: View {
    @Binding var selectedCurrency: Currency?
    
    var body: some View {
        List {
            ForEach(Currency.allCases, id: \.self) { currency in
                HStack {
                    CurrencyItem(
                        currency: currency,
                        isSelected: selectedCurrency == currency)
                    
                    Spacer()
                    
                    if selectedCurrency == currency {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .onTapGesture {
                    selectedCurrency = currency
                }
            }
        }
        .listStyle(.plain)
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .contentMargins(.horizontal, 0, for: .scrollIndicators)
    }
}

private struct CurrencySelectorViewPreview: View {
    @State var selectedCurrency: Currency?

    var body: some View {
        CurrencySelectorView(selectedCurrency: $selectedCurrency)
    }
}

#Preview {
    CurrencySelectorViewPreview()
}
