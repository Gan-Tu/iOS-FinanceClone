//
//  Account.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import Foundation
import SwiftData

@Model
final class Account {
    var id: String = UUID().uuidString
    
    var name: String = ""
    var journal: Journal? = nil
    
    var accountDescription: String = ""
    var category: AccountCategory = AccountCategory.asset
    var currency: Currency = Currency.USD
    
    init(name: String,
         journal: Journal,
         category: AccountCategory,
         description: String = "",
         currency: Currency = .USD) {
        self.name = name
        self.journal = journal
        self.accountDescription = description
        self.category = category
        self.currency = currency
    }
}

