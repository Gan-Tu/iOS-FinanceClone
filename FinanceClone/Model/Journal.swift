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
        var seenTrans = Set<String>()
        if let accounts = self.accounts {
            for account in accounts {
                if let entries = account.cash_flow_entries {
                    for entry in entries {
                        if entry.transactionRef != nil {
                            seenTrans.insert(entry.transactionRef!.id)
                        }
                    }
                }
            }
        }
        return seenTrans.count
    }
}

enum JournalTemplate: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}
