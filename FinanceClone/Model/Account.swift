//
//  Account.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Account : Identifiable, ObservableObject {
    var id: String = UUID().uuidString
    
    var name: String = ""
    var journal: Journal? = nil
    
    var accountDescription: String = ""
    var category: AccountCategory = AccountCategory.asset
    var currency: Currency = Currency.USD
    var label: AccountLabel? = nil
    
    @Relationship(deleteRule: .cascade, inverse: \CashFlowEntry.account)
    var cash_flow_entries: [CashFlowEntry]? = []
    
    init(name: String,
         journal: Journal,
         category: AccountCategory,
         description: String = "",
         currency: Currency = .USD,
         label: AccountLabel? = nil) {
        self.name = name
        self.journal = journal
        self.accountDescription = description
        self.category = category
        self.currency = currency
        self.label = label
    }
    
    func getFullDetailName() -> String {
        return "\(category.rawValue):\(name)"
    }
    
    var balance: Double {
        // TODO(tugan): calculate balance from cashflow
        if cash_flow_entries != nil {
            return cash_flow_entries!.reduce(0, { cur, entry in
                cur + entry.amount
            })
        }
        return 0.0
    }
    
    func describeBalance() -> String {
        return formatAmount(amount: self.balance, currency: self.currency)
    }
    
    func balanceUntil(date: Date) -> Double {
        // TODO(tugan): calculate balance from cashflow
        if cash_flow_entries != nil {
            return cash_flow_entries!.reduce(0, { cur, entry in
                if entry.transactionRef?.date != nil &&
                    entry.transactionRef!.date! < date {
                    return cur + entry.amount
                }
                return cur
            })
        }
        return 0.0
    }
}



enum AccountLabel: String, CaseIterable, Codable {
    case gray = "Gray"
    case red = "Red"
    case brown = "Brown"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case cyan = "Cyan"
    case blue = "Blue"
    case purple = "Purple"
    case pink = "Pink"
    
    var color: Color {
        switch self {
        case .gray: return Color.gray
        case .red: return Color.red
        case .brown: return Color.brown
        case .orange: return Color.orange
        case .yellow: return Color.yellow
        case .green: return Color.green
        case .cyan: return Color.cyan
        case .blue: return Color.blue
        case .purple: return Color.purple
        case .pink: return Color.pink
        }
    }
}
