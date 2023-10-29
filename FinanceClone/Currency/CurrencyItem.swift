//
//  CurrencyItem.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import SwiftUI

struct CurrencyItem: View {
    let currency: Currency
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text(currency.name)
                .if(isSelected) {
                    $0.foregroundStyle(Color.accentColor)
                }
            Text(currency.rawValue)
                .foregroundStyle(.secondary)
                .font(.footnote)
        })
    }
}

#Preview {
    VStack(alignment: .leading) {
        CurrencyItem(currency: .USD, isSelected: false)
        CurrencyItem(currency: .GBP, isSelected: true)
    }
}
