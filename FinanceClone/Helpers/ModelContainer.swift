//
//  ModelContainer.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftUI
import SwiftData

let schema = Schema([
    Journal.self,
    Account.self,
    TransactionEntry.self,
    CashFlowEntry.self,
])

func createMainModelContainer() -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}

@MainActor @discardableResult
func addTransaction(container: ModelContainer, from: Account, to: Account, amount: Double, note: String, payee: String, currency: Currency? = nil) -> TransactionEntry {
    let transaction = TransactionEntry(date: Date.now, note: note, payee: payee, number: "", cleared: true)
    container.mainContext.insert(transaction)
    let flow1 = CashFlowEntry(transactionRef: transaction, account: from, amount: -amount, currency: currency)
    let flow2 = CashFlowEntry(transactionRef: transaction, account: to, amount: amount, currency: currency)
    container.mainContext.insert(flow1)
    container.mainContext.insert(flow2)
    return transaction
}

@MainActor @discardableResult 
func initJournal(name: String, currency: Currency?, withTemplate: JournalTemplate, container: ModelContainer) -> Journal {
    let journal = Journal(name: name)
    if currency != nil {
        journal.currencies = [currency!]
    }
    container.mainContext.insert(journal)
    
    if withTemplate == .personal {
        let checking = Account(name: "Checking", journal: journal, category: .asset)
        let cash = Account(name: "Cash", journal: journal, category: .asset)
        let credit = Account(name: "Credit Card", journal: journal, category: .liabilities)
        let salary = Account(name: "Salary", journal: journal, category: .income, label: .green)
        let household = Account(name: "Household", journal: journal, category: .expense, label: .red)
        let savings = Account(name: "Savings", journal: journal, category: .expense, label: .brown)
        let transportation = Account(name: "Transportation", journal: journal, category: .expense, label: .orange)
        let utilities = Account(name: "Utilities", journal: journal, category: .expense, label: .yellow)
        let personal = Account(name: "Personal", journal: journal, category: .expense, label: .green)
        let health = Account(name: "Health Care", journal: journal, category: .expense, label: .cyan)
        let food = Account(name: "Food", journal: journal, category: .expense, label: .blue)
        let entertainment = Account(name: "Entertainment", journal: journal, category: .expense, label: .pink)
        let opening_balance = Account(name: "Opening Balance", journal: journal, category: .equity)

        journal.accounts?.append(checking)
        journal.accounts?.append(cash)
        journal.accounts?.append(credit)
        journal.accounts?.append(salary)
        journal.accounts?.append(household)
        journal.accounts?.append(savings)
        journal.accounts?.append(transportation)
        journal.accounts?.append(utilities)
        journal.accounts?.append(personal)
        journal.accounts?.append(health)
        journal.accounts?.append(food)
        journal.accounts?.append(entertainment)
        journal.accounts?.append(opening_balance)
        
        addTransaction(container: container, from: salary, to: checking, amount: 5000, note: "Paycheck", payee: "Google", currency: currency)
        addTransaction(container: container, from: checking, to: transportation, amount: 52.1, note: "Airport to Home", payee: "Uber", currency: currency)
        addTransaction(container: container, from: credit, to: utilities, amount: 94.2, note: "Electricity", payee: "Edison", currency: currency)
        addTransaction(container: container, from: credit, to: food, amount: 121.3, note: "Meal Prep Kit", payee: "Hello Fresh", currency: currency)
        addTransaction(container: container, from: checking, to: credit, amount: 215.5, note: "Credit Card Payment", payee: "", currency: currency)
        
    } else if withTemplate == .business {
        journal.accounts?.append(Account(name: "Checking", journal: journal, category: .asset))
        journal.accounts?.append(Account(name: "Petty Cash", journal: journal, category: .asset))
        journal.accounts?.append(Account(name: "Receivables", journal: journal, category: .asset))
        journal.accounts?.append(Account(name: "Inventory", journal: journal, category: .asset))
        
        journal.accounts?.append(Account(name: "Credit Card", journal: journal, category: .liabilities))
        journal.accounts?.append(Account(name: "Loan", journal: journal, category: .liabilities))
        journal.accounts?.append(Account(name: "Other Payable", journal: journal, category: .liabilities))
        journal.accounts?.append(Account(name: "Sales Tax", journal: journal, category: .liabilities))
        
        
        journal.accounts?.append(Account(name: "Sales", journal: journal, category: .income, label: .green))
        journal.accounts?.append(Account(name: "Interest", journal: journal, category: .income, label: .purple))
        
        journal.accounts?.append(Account(name: "Purchase of Goods", journal: journal, category: .expense, label: .red))
        journal.accounts?.append(Account(name: "Advertising", journal: journal, category: .expense, label: .brown))
        journal.accounts?.append(Account(name: "Payroll", journal: journal, category: .expense, label: .orange))
        journal.accounts?.append(Account(name: "Office", journal: journal, category: .expense, label: .yellow))
        journal.accounts?.append(Account(name: "Travel", journal: journal, category: .expense, label: .green))
        journal.accounts?.append(Account(name: "Insurance", journal: journal, category: .expense, label: .cyan))
        journal.accounts?.append(Account(name: "Bank Fees", journal: journal, category: .expense, label: .blue))
        journal.accounts?.append(Account(name: "Depreciation", journal: journal, category: .expense, label: .purple))
        
        journal.accounts?.append(Account(name: "Capital", journal: journal, category: .equity))
        journal.accounts?.append(Account(name: "Drawing", journal: journal, category: .equity))
        journal.accounts?.append(Account(name: "Initial Balance", journal: journal, category: .equity))
    }
    return journal;
}

@MainActor func initPreviewJournal(container: ModelContainer) -> Journal {
    initJournal(name: "Personal", currency: .USD, withTemplate: .personal, container: container)
}

@MainActor func createPreviewModelContainer(seedData: Bool = true) -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        if seedData {
            initJournal(name: "Personal", currency: .USD, withTemplate: .personal, container: container)
            initJournal(name: "Business", currency: .USD, withTemplate: .business, container: container)
        }
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}
