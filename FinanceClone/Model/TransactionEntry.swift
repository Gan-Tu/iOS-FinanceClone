//
//  TransactionEntry.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class TransactionEntry : Identifiable{
    var id: String = UUID().uuidString

    var journal: Journal? = nil
    
    var date: Date? = nil
    var note: String = ""
    var payee: String = ""
    var number: String = ""
    var cleared: Bool = true
    // TODO(tugan): add attachments
    
    @Relationship(deleteRule: .cascade, inverse: \CashFlowEntry.transactionRef)
    var entries: [CashFlowEntry]? = []
    
    init(date: Date,
         note: String,
         payee: String,
         number: String,
         cleared: Bool,
         journal: Journal? = nil,
         entries: [CashFlowEntry] = []) {
        self.date = date
        self.note = note
        self.payee = payee
        self.number = number
        self.cleared = cleared
        self.journal = journal
        self.entries = entries
    }
    
    convenience init(date: Date, note: String, payee: String, cleared: Bool, number: String = "", journal: Journal? = nil) {
        self.init(date: date, note: note, payee: payee, number: number, cleared: cleared, journal: journal, entries: [])
    }
    
    func copy() -> TransactionEntry {
        let copy = TransactionEntry(date: self.date ?? Date(),
                                    note: self.note,
                                    payee: self.payee,
                                    number: self.number,
                                    cleared: self.cleared,
                                    journal: self.journal,
                                    entries: self.entries ?? [])
        return copy
    }
    
    @Transient
    var debitedAccounts: [Account] {
        if self.entries != nil {
            return self.entries!.filter({ $0.amount > 0 && $0.account != nil }).map({ $0.account! })
        }
        return []
    }
    
    @Transient
    var creditedAccounts: [Account] {
        if self.entries != nil {
            return self.entries!.filter({ $0.amount < 0 && $0.account != nil }).map({ $0.account! })
        }
        return []
    }

    // Backwards-compatible aliases used by older views.
    @Transient
    var debitedAcconuts: [Account] { debitedAccounts }

    @Transient
    var creditedAcconuts: [Account] { creditedAccounts }
    
    @Transient
    var amount: Double {
        guard self.entries != nil else {
            return 0.0
        }
        return self.entries!.reduce(0, { x, entry in
            if entry.amount > 0 {
                return x + entry.amount
            }
            return x
        })
    }
    
    @Transient
    var currencySymbol: String {
        if self.entries != nil {
            for entry in self.entries! {
                if entry.currency != nil {
                    return entry.currency!.symbol
                }
            }
        }
        return "$"
    }

    @Transient
    var sortedEntries: [CashFlowEntry] {
        guard let entries else { return [] }
        return entries.sorted { lhs, rhs in
            if lhs.account?.name != rhs.account?.name {
                return (lhs.account?.name ?? "") < (rhs.account?.name ?? "")
            }
            return lhs.id < rhs.id
        }
    }

    @Transient
    var sortDate: Date {
        date ?? .distantPast
    }

    func belongs(to journal: Journal) -> Bool {
        if self.journal?.id == journal.id {
            return true
        }
        return (self.entries ?? []).contains(where: { $0.account?.journal?.id == journal.id })
    }

    func amount(for account: Account) -> Double {
        (self.entries ?? []).reduce(0) { partial, entry in
            guard let entryAccount = entry.account else { return partial }
            return entryAccount.id == account.id ? partial + entry.amount : partial
        }
    }

    @Transient
    var preferredAccountForRunningBalance: Account? {
        guard let entries else { return nil }
        let grouped = Dictionary(grouping: entries.compactMap { entry -> (Account, Double)? in
            guard let account = entry.account else { return nil }
            return (account, entry.amount)
        }, by: { $0.0.id })

        let byAccount: [(account: Account, amount: Double)] = grouped.compactMap { _, groupedEntries in
            guard let first = groupedEntries.first else { return nil }
            let total = groupedEntries.reduce(0) { $0 + $1.1 }
            return (first.0, total)
        }

        let balanceCategories: Set<AccountCategory> = [.asset, .liabilities, .equity]

        if let account = byAccount
            .filter({ balanceCategories.contains($0.account.category) && $0.amount < 0 })
            .sorted(by: { abs($0.amount) > abs($1.amount) })
            .first?.account {
            return account
        }

        if let account = byAccount
            .filter({ balanceCategories.contains($0.account.category) && $0.amount > 0 })
            .sorted(by: { abs($0.amount) > abs($1.amount) })
            .first?.account {
            return account
        }

        if let account = byAccount
            .filter({ $0.amount < 0 })
            .sorted(by: { abs($0.amount) > abs($1.amount) })
            .first?.account {
            return account
        }

        return byAccount.sorted(by: { abs($0.amount) > abs($1.amount) }).first?.account
    }
    
    func describeAmount() -> String {
        let isIncome = self.entries != nil && self.entries!.contains(where: { $0.account?.category == .income })
        return formatAmount(amount: isIncome ? amount : -amount, currencySymbol: currencySymbol)
    }
}
