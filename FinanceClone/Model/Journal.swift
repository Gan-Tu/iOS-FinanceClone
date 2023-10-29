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

    var creationTimestamp: Date? = nil
    var name: String = ""
    var numTransactions: Int = 0

    var currencies: [Currency] = [Currency.USD]
    
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

