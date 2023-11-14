//
//  CashFlowEntry.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class CashFlowEntry {
    var id: String = UUID().uuidString

    var transactionRef: TransactionEntry? = nil
    var account: Account? = nil
    var amount: Double = 0.0
    var currency: Currency? = nil
    
    init(transactionRef: TransactionEntry, account: Account?, amount: Double, currency: Currency? = nil) {
        self.transactionRef = transactionRef
        self.account = account
        self.amount = amount
        self.currency = currency
    }

    func describeAmount() -> String {
        return "\(amount > 0 ? "" : "-")\(currency?.symbol ?? "$")\(String(format: "%.2f", abs(amount)))"
    }
}
