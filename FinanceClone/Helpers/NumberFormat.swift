//
//  NumberFormat.swift
//  FinanceClone
//
//  Created by Gan Tu on 7/6/24.
//

import Foundation

func formatAmount(amount: Double, currencySymbol: String) -> String {
    let amountSign = amount >= 0 ? "" : "-"
    return "\(amountSign)\(currencySymbol)\(abs(amount).formatted(.number.precision(.fractionLength(2))))"
}

func formatAmount(amount: Double, currency: Currency) -> String {
    return formatAmount(amount: amount, currencySymbol: currency.symbol)
}
