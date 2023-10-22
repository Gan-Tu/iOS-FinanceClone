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
    var subAccounts: [String] = []
    
    init(name: String) {
        self.name = name
        self.subAccounts = ["Sub-Account 1", "Sub-Account 2", "Sub-Account 3"]
    }
    
    init(name: String, accountDescription: String) {
        self.name = name
        self.accountDescription = accountDescription
        self.subAccounts = ["Sub-Account 1", "Sub-Account 2", "Sub-Account 3"]
    }
}

