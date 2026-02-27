//
//  TransactionPageView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

enum TransactionPageFilter: Hashable {
    case all
    case uncleared
    case repeating
    case currency(Currency)

    var title: String {
        switch self {
        case .all:
            return "All"
        case .uncleared:
            return "Uncleared"
        case .repeating:
            return "Repeating"
        case .currency(let currency):
            return currency.name
        }
    }
}

private struct TransactionListRow: Identifiable {
    let id: String
    let transaction: TransactionEntry
    let amount: Double
    let amountCurrency: Currency
    let runningBalance: Double?
    let runningBalanceCurrency: Currency?
    let primaryAccount: Account?
}

private struct TransactionDaySection: Identifiable {
    let id: String
    let title: String
    let rows: [TransactionListRow]
}

struct TransactionPageView: View {
    let filter: TransactionPageFilter
    let journal: Journal

    @Query(sort: [
        SortDescriptor(\TransactionEntry.date, order: .reverse),
        SortDescriptor(\TransactionEntry.id, order: .reverse)
    ])
    private var allTransactions: [TransactionEntry]

    private var filteredTransactions: [TransactionEntry] {
        allTransactions
            .filter({ $0.belongs(to: journal) })
            .filter(matchesFilter(_:))
            .sorted { lhs, rhs in
                if lhs.sortDate != rhs.sortDate {
                    return lhs.sortDate > rhs.sortDate
                }
                return lhs.id > rhs.id
            }
    }

    private var rows: [TransactionListRow] {
        let transactionsAscending = filteredTransactions.sorted { lhs, rhs in
            if lhs.sortDate != rhs.sortDate {
                return lhs.sortDate < rhs.sortDate
            }
            return lhs.id < rhs.id
        }

        var runningBalanceByAccount: [String: Double] = [:]
        var calculatedRows: [TransactionListRow] = []

        for transaction in transactionsAscending {
            for entry in transaction.entries ?? [] {
                guard let account = entry.account else { continue }
                runningBalanceByAccount[account.id, default: 0] += entry.amount
            }

            let primaryAccount = transaction.preferredAccountForRunningBalance
            let amountCurrency: Currency = {
                if let primaryAccount {
                    return primaryAccount.currency
                }
                return transaction.sortedEntries.first?.currency
                    ?? transaction.sortedEntries.first?.account?.currency
                    ?? journal.defaultCurreny
            }()

            let amountValue: Double = {
                if let primaryAccount {
                    return transaction.amount(for: primaryAccount)
                }
                let hasIncome = (transaction.entries ?? []).contains(where: { $0.account?.category == .income })
                return hasIncome ? transaction.amount : -transaction.amount
            }()

            let runningBalance: Double? = primaryAccount.flatMap { account in
                runningBalanceByAccount[account.id]
            }

            calculatedRows.append(
                TransactionListRow(
                    id: transaction.id,
                    transaction: transaction,
                    amount: amountValue,
                    amountCurrency: amountCurrency,
                    runningBalance: runningBalance,
                    runningBalanceCurrency: primaryAccount?.currency,
                    primaryAccount: primaryAccount
                )
            )
        }

        return calculatedRows.reversed()
    }

    private var sections: [TransactionDaySection] {
        let grouped = Dictionary(grouping: rows) { row in
            Calendar.current.startOfDay(for: row.transaction.sortDate)
        }

        let sortedDays = grouped.keys.sorted(by: >)

        return sortedDays.map { day in
            let sectionRows = (grouped[day] ?? []).sorted { lhs, rhs in
                if lhs.transaction.sortDate != rhs.transaction.sortDate {
                    return lhs.transaction.sortDate > rhs.transaction.sortDate
                }
                return lhs.transaction.id > rhs.transaction.id
            }
            return TransactionDaySection(
                id: String(day.timeIntervalSinceReferenceDate),
                title: sectionTitle(for: day),
                rows: sectionRows
            )
        }
    }

    var body: some View {
        Group {
            if sections.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "tray",
                    description: Text(emptyStateDescription)
                )
            } else {
                List {
                    ForEach(sections) { section in
                        Section {
                            ForEach(section.rows) { row in
                                ZStack {
                                    NavigationLink(
                                        destination: TransactionDetailView(txn: row.transaction)
                                            .environmentObject(journal)
                                    ) {
                                        EmptyView()
                                    }
                                    .opacity(0)

                                    TransactionPreviewRow(
                                        entry: row.transaction,
                                        displayAmount: row.amount,
                                        displayAmountCurrency: row.amountCurrency,
                                        runningBalance: row.runningBalance,
                                        runningBalanceCurrency: row.runningBalanceCurrency,
                                        primaryAccount: row.primaryAccount
                                    )
                                }
                                .listRowInsets(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            }
                        } header: {
                            Text(section.title)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .listStyle(.plain)
                .listSectionSpacing(.compact)
            }
        }
        .navigationTitle(filter.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func matchesFilter(_ transaction: TransactionEntry) -> Bool {
        switch filter {
        case .all:
            return true
        case .uncleared:
            return !transaction.cleared
        case .repeating:
            return false
        case .currency(let currency):
            return (transaction.entries ?? []).contains {
                let entryCurrency = $0.currency ?? $0.account?.currency
                return entryCurrency == currency
            }
        }
    }

    private func sectionTitle(for day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) {
            return "TODAY"
        }
        if calendar.isDateInYesterday(day) {
            return "YESTERDAY"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: day).uppercased()
    }

    private var emptyStateDescription: String {
        switch filter {
        case .all:
            return "Create your first transaction from the compose button."
        case .uncleared:
            return "All transactions are currently marked as cleared."
        case .repeating:
            return "Repeating entries are not configured yet."
        case .currency(let currency):
            return "No transactions found in \(currency.rawValue)."
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationStack {
        TransactionPageView(filter: .all, journal: journal)
    }
    .modelContainer(previewContainer)
}
