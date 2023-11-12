//
//  TransactionEntry.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class TransactionEntry {
    var id: String = UUID().uuidString
    
    var date: Date? = nil
    var note: String = ""
    var payee: String = ""
    var number: String = ""
    var cleared: Bool = true
    // TODO(tugan): add attachments
    
    @Relationship(deleteRule: .cascade, inverse: \CashFlowEntry.transactionRef)
    var entries: [CashFlowEntry]? = []
    
    init(date: Date, note: String, payee: String, number: String, cleared: Bool, entries: [CashFlowEntry] = []) {
        self.date = date
        self.note = note
        self.payee = payee
        self.number = number
        self.cleared = cleared
        self.entries = entries
    }
    
    convenience init(date: Date, note: String, payee: String, cleared: Bool, number: String = "") {
        self.init(date: date, note: note, payee: payee, number: number, cleared: cleared, entries: [])
    }
    
    @Transient
    var debitedAcconuts: [Account] {
        if self.entries != nil {
            return self.entries!.filter({ $0.amount > 0 && $0.account != nil }).map({ $0.account! })
        }
        return []
    }
    
    @Transient
    var creditedAcconuts: [Account] {
        if self.entries != nil {
            return self.entries!.filter({ $0.amount < 0 && $0.account != nil }).map({ $0.account! })
        }
        return []
    }
    
    @Transient
    var amount: Double {
        guard self.entries != nil else {
            return 0.0
        }
        return self.entries!.reduce(0, { x, entry in
            if entry.amount > 0 {
                return x + entry.amount
            }
            return x
        })
    }
    
    @Transient
    var currencySymbol: String {
        if self.entries != nil {
            for entry in self.entries! {
                if entry.currency != nil {
                    return entry.currency!.symbol
                }
            }
        }
        return "$"
    }
    
    func describeAmount() -> String {
        let isIncome = self.entries != nil && self.entries!.contains(where: { $0.account?.category == .income })
        let amountSign = isIncome ? "" : "-"
        return "\(amountSign)\(currencySymbol)\(String(format: "%.2f", amount))"
    }
}

