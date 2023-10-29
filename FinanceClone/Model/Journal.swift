//
//  Journal.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import Foundation
import SwiftData

@Model
final class Journal {
    var id: String = UUID().uuidString

    var creationTimestamp: Date? = nil
    var name: String = ""
    var numTransactions: Int = 0

    // TODO(tugan): fetch this from journal's currency
    var currency: String = "US Dollar"
    
    @Relationship(deleteRule: .cascade, inverse: \Account.journal)
    var accounts: [Account]? = []
    
    init(name: String) {
        self.name = name
        self.creationTimestamp = Date()
    }
    
    init(name: String, numTransactions: Int) {
        self.name = name
        self.numTransactions = numTransactions
    }
}

