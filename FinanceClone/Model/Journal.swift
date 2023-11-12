//
//  Journal.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import Foundation
import SwiftData

@Model
final class Journal: ObservableObject {
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
    
    var numTransactions : Int {
        var total = 0
        if let accounts = self.accounts {
            for account in accounts {
                if let entries = account.cash_flow_entries {
                    total += entries.count
                }
            }
        }
        return total
    }
}

enum JournalTemplate: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}
