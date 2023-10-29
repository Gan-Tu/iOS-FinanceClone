//
//  AccountCategory.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import Foundation

enum AccountCategory: String, CaseIterable, Codable {
    case asset = "Asset"
    case liabilities = "Liabilities"
    case income = "Income"
    case expense = "Expense"
    case equity = "Equity"
}
