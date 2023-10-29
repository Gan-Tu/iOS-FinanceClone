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
    }
}

#Preview {
    @State var selectedCurrency: Currency?
    return CurrencySelectorView(selectedCurrency: $selectedCurrency)
}
