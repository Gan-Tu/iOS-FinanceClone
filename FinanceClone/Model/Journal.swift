//
//  Journal.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import Foundation
import SwiftData

@Model
final class Journal: Identifiable, ObservableObject {
    var id: String = UUID().uuidString
    
    var name: String = ""
    var creationTimestamp: Date? = nil
    var currencies: [Currency] = [Currency.USD]
    
    @Relationship(deleteRule: .cascade, inverse: \Account.journal)
    var accounts: [Account]? = []

    @Relationship(deleteRule: .cascade, inverse: \TransactionEntry.journal)
    var transactions: [TransactionEntry]? = []
    
    init(name: String) {
        self.name = name
        self.creationTimestamp = Date()
        self.accounts = []
    }
    
    @Transient
    var defaultCurreny: Currency {
        self.currencies.isEmpty ? Currency.USD : self.currencies[0]
    }
    
    @Transient
    var numTransactions : Int {
        var seenTransactionIDs = Set<String>()

        for transaction in transactions ?? [] {
            seenTransactionIDs.insert(transaction.id)
        }

        for account in accounts ?? [] {
            for entry in account.cash_flow_entries ?? [] {
                if let transaction = entry.transactionRef {
                    seenTransactionIDs.insert(transaction.id)
                }
            }
        }

        return seenTransactionIDs.count
    }
}

enum JournalTemplate: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}
