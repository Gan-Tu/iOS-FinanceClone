//
//  ModelContainer.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftData


let schema = Schema([
    Journal.self,
    Account.self,
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
func initJournal(name: String, currency: Currency?, withTemplate: JournalTemplate, container: ModelContainer) -> Journal {
    let journal = Journal(name: name)
    if currency != nil {
        journal.currencies = [currency!]
    }
    container.mainContext.insert(journal)
    
    if withTemplate == .personal {
        journal.accounts?.append(Account(name: "Checking", journal: journal, category: .asset))
        journal.accounts?.append(Account(name: "Cash", journal: journal, category: .asset))
        
        journal.accounts?.append(Account(name: "Credit Card", journal: journal, category: .liabilities))
        
        journal.accounts?.append(Account(name: "Salary", journal: journal, category: .income, label: .green))
        
        journal.accounts?.append(Account(name: "Household", journal: journal, category: .expense, label: .red))
        journal.accounts?.append(Account(name: "Savings", journal: journal, category: .expense, label: .brown))
        journal.accounts?.append(Account(name: "Transportation", journal: journal, category: .expense, label: .orange))
        journal.accounts?.append(Account(name: "Utilities", journal: journal, category: .expense, label: .yellow))
        journal.accounts?.append(Account(name: "Personal", journal: journal, category: .expense, label: .green))
        journal.accounts?.append(Account(name: "Health Care", journal: journal, category: .expense, label: .cyan))
        journal.accounts?.append(Account(name: "Food", journal: journal, category: .expense, label: .blue))
        journal.accounts?.append(Account(name: "Entertainment", journal: journal, category: .expense, label: .pink))
        
        journal.accounts?.append(Account(name: "Opening Balance", journal: journal, category: .equity))
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
