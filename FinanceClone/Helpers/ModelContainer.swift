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
        health.accountDescription = "Medication, Doctor Visits, Co-Pays, etc."
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

@MainActor  @discardableResult
func seedIncomeTransaction(container: ModelContainer, journal: Journal) -> TransactionEntry {
    let checking = Account(name: "Checking", journal: journal, category: .asset)
    let salary = Account(name: "Salary", journal: journal, category: .income, label: .green)
    
    journal.accounts?.removeAll(where: {
        $0.name == checking.name || $0.name == salary.name
    })
    journal.accounts?.append(checking)
    journal.accounts?.append(salary)
    
    return addTransaction(container: container, from: salary, to: checking, amount: 5000, note: "Paycheck", payee: "Google", currency: Currency.USD)
}

@MainActor  @discardableResult
func seedExpenseTransaction(container: ModelContainer, journal: Journal) -> TransactionEntry {
    let credit = Account(name: "Credit Card", journal: journal, category: .liabilities)
    let utilities = Account(name: "Utilities", journal: journal, category: .expense, label: .yellow)
    
    journal.accounts?.removeAll(where: {
        $0.name == credit.name || $0.name == utilities.name
    })
    journal.accounts?.append(credit)
    journal.accounts?.append(utilities)
    
    return addTransaction(container: container, from: credit, to: utilities, amount: 94.223, note: "Electricity", payee: "Edison", currency: Currency.USD)
}

@MainActor @discardableResult
func seedMutliAccountTransaction(container: ModelContainer, journal: Journal) -> TransactionEntry {
    let cash = Account(name: "Cash", journal: journal, category: .asset)
    let transportation = Account(name: "Transportation", journal: journal, category: .expense, label: .orange)
    let household = Account(name: "Household", journal: journal, category: .expense, label: .red)
    
    journal.accounts?.removeAll(where: {
        $0.name == cash.name || $0.name == transportation.name || $0.name == household.name
    })
    journal.accounts?.append(cash)
    journal.accounts?.append(transportation)
    journal.accounts?.append(household)
    
    let transaction = TransactionEntry(date: Date.now, note: "Multiple Trans", payee: "Uber", number: "", cleared: true)
    container.mainContext.insert(transaction)

    let flow1 = CashFlowEntry(transactionRef: transaction, account: cash, amount: -10, currency: .USD)
    let flow2 = CashFlowEntry(transactionRef: transaction, account: transportation, amount: 8.5, currency: .USD)
    let flow3 = CashFlowEntry(transactionRef: transaction, account: household, amount: 1.5, currency: .USD)
    container.mainContext.insert(flow1)
    container.mainContext.insert(flow2)
    container.mainContext.insert(flow3)
    
    return transaction
}

@MainActor @discardableResult
func initPreviewJournal(container: ModelContainer, seedTransactions: Bool = true) -> Journal {
    let journal = initJournal(name: "Personal", currency: .USD, withTemplate: .personal, container: container)
    if seedTransactions {
        seedIncomeTransaction(container: container, journal: journal)
        seedExpenseTransaction(container: container, journal: journal)
        seedMutliAccountTransaction(container: container, journal: journal)
    }
    return journal
}

@MainActor func createPreviewModelContainer(seedData: Bool = true) -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        if seedData {
            let journal = initJournal(name: "Personal", currency: .USD, withTemplate: .personal, container: container)
            seedIncomeTransaction(container: container, journal: journal)
            seedExpenseTransaction(container: container, journal: journal)
            seedMutliAccountTransaction(container: container, journal: journal)
            
            initJournal(name: "Business", currency: .USD, withTemplate: .business, container: container)
        }
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}
