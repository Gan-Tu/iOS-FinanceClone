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


@MainActor func createPreviewModelContainer(seedData: Bool = true) -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        if seedData {
            let personal = seedJournal(container: container, name: "Personal Journal")
            initPersonalTemplate(container: container, journal: personal)
            
            let businesss = seedJournal(container: container, name: "Businesss Journal")
            initBusinessTemplate(container: container, journal: businesss)
        }
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}

@MainActor func seedJournal(container: ModelContainer, name: String = "Test Journal") -> Journal {
    let journal = Journal(name: name)
    container.mainContext.insert(journal)
    return journal
}


@MainActor func initPersonalTemplate(container: ModelContainer, journal: Journal) {
    journal.accounts?.append(Account(name: "Checking", journal: journal, category: .asset))
    journal.accounts?.append(Account(name: "Cash", journal: journal, category: .asset))
    
    journal.accounts?.append(Account(name: "Credit Card", journal: journal, category: .liabilities))

    journal.accounts?.append(Account(name: "Salary", journal: journal, category: .income))

    journal.accounts?.append(Account(name: "Household", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Savings", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Transportation", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Utilities", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Personal", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Health Care", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Food", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Entertainment", journal: journal, category: .expense))

    journal.accounts?.append(Account(name: "Opening Balance", journal: journal, category: .equity))
}

@MainActor func initBusinessTemplate(container: ModelContainer, journal: Journal) {
    journal.accounts?.append(Account(name: "Checking", journal: journal, category: .asset))
    journal.accounts?.append(Account(name: "Petty Cash", journal: journal, category: .asset))
    journal.accounts?.append(Account(name: "Receivables", journal: journal, category: .asset))
    journal.accounts?.append(Account(name: "Inventory", journal: journal, category: .asset))

    journal.accounts?.append(Account(name: "Credit Card", journal: journal, category: .liabilities))
    journal.accounts?.append(Account(name: "Loan", journal: journal, category: .liabilities))
    journal.accounts?.append(Account(name: "Other Payable", journal: journal, category: .liabilities))
    journal.accounts?.append(Account(name: "Sales Tax", journal: journal, category: .liabilities))
    

    journal.accounts?.append(Account(name: "Sales", journal: journal, category: .income))
    journal.accounts?.append(Account(name: "Interest", journal: journal, category: .income))

    journal.accounts?.append(Account(name: "Purchase of Goods", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Advertising", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Payroll", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Office", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Travel", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Insurance", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Bank Fees", journal: journal, category: .expense))
    journal.accounts?.append(Account(name: "Depreciation", journal: journal, category: .expense))

    journal.accounts?.append(Account(name: "Capital", journal: journal, category: .equity))
    journal.accounts?.append(Account(name: "Drawing", journal: journal, category: .equity))
    journal.accounts?.append(Account(name: "Initial Balance", journal: journal, category: .equity))
}
