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
    var accountDescription: String = ""
    var category: AccountCategory?
    
    // TODO(tugan): add currency

    var journal: Journal?
    
    init(name: String, category: AccountCategory) {
        self.name = name
        self.category = category
    }
    
    init(name: String, accountDescription: String, category: AccountCategory) {
        self.name = name
        self.category = category
        self.accountDescription = accountDescription
    }
}

