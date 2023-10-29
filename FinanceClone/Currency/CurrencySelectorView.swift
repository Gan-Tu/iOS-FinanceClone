//
//  CurrencySelectorView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI


struct CurrencySelectorRow: View {
    let currency: Currency
    let isSelected: Bool
    
    var body: some View {
        HStack {
            CurrencyItem(currency: currency, isSelected: isSelected)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}


struct CurrencySelectorView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedCurrency: Currency = .USD
    
    let showCancelButton: Bool
    let saveCallback: (Currency) -> Void
    
    var body: some View {
        NavigationStack {
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
            .navigationBarTitle("Currencies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showCancelButton {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: {
                            dismiss();
                        })
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: {
                        saveCallback(selectedCurrency)
                        dismiss();
                    })
                }
            }
        }
    }
}

#Preview("no cancel") {
    CurrencySelectorView(showCancelButton: false) { currency in
        print("selected \(currency)")
    }
}


#Preview("with cancel") {
    CurrencySelectorView(showCancelButton: true) { currency in
        print("selected \(currency)")
    }
}
