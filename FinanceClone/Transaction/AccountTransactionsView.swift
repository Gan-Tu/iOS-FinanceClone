//
//  AccountTransactionsView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import SwiftUI
import SwiftData

private struct AccountTransactionRow: Identifiable {
    let id: String
    let transaction: TransactionEntry
    let amount: Double
    let runningBalance: Double
}

private struct AccountTransactionSection: Identifiable {
    let id: String
    let title: String
    let rows: [AccountTransactionRow]
}

struct AccountTransactionsView: View {
    @EnvironmentObject var journal: Journal
    var account: Account

    @Query(sort: [
        SortDescriptor(\TransactionEntry.date, order: .reverse),
        SortDescriptor(\TransactionEntry.id, order: .reverse)
    ])
    private var allTransactions: [TransactionEntry]

    private var accountTransactions: [TransactionEntry] {
        allTransactions
            .filter({ $0.belongs(to: journal) })
            .filter({ abs($0.amount(for: account)) > 0.000001 })
            .sorted { lhs, rhs in
                if lhs.sortDate != rhs.sortDate {
                    return lhs.sortDate > rhs.sortDate
                }
                return lhs.id > rhs.id
            }
    }

    private var rows: [AccountTransactionRow] {
        let ascending = accountTransactions.reversed()
        var running = 0.0
        var calculated: [AccountTransactionRow] = []

        for transaction in ascending {
            let amount = transaction.amount(for: account)
            running += amount
            calculated.append(
                AccountTransactionRow(
                    id: transaction.id,
                    transaction: transaction,
                    amount: amount,
                    runningBalance: running
                )
            )
        }

        return calculated.reversed()
    }

    private var sections: [AccountTransactionSection] {
        let grouped = Dictionary(grouping: rows) { row in
            Calendar.current.startOfDay(for: row.transaction.sortDate)
        }
        let sortedDays = grouped.keys.sorted(by: >)

        return sortedDays.map { day in
            let dayRows = (grouped[day] ?? []).sorted { lhs, rhs in
                if lhs.transaction.sortDate != rhs.transaction.sortDate {
                    return lhs.transaction.sortDate > rhs.transaction.sortDate
                }
                return lhs.transaction.id > rhs.transaction.id
            }
            return AccountTransactionSection(
                id: String(day.timeIntervalSinceReferenceDate),
                title: sectionTitle(for: day),
                rows: dayRows
            )
        }
    }

    var body: some View {
        Group {
            if sections.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "tray",
                    description: Text("This account has no posted entries.")
                )
            } else {
                List {
                    ForEach(sections) { section in
                        Section {
                            ForEach(section.rows) { row in
                                ZStack {
                                    NavigationLink(destination: TransactionDetailView(txn: row.transaction).environmentObject(journal)) {
                                        EmptyView()
                                    }
                                    .opacity(0)

                                    TransactionPreviewRow(
                                        entry: row.transaction,
                                        displayAmount: row.amount,
                                        displayAmountCurrency: account.currency,
                                        runningBalance: row.runningBalance,
                                        runningBalanceCurrency: account.currency,
                                        primaryAccount: account
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
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.inline)
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
        return formatter.string(from: day).uppercased()
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    let account = journal.accounts!.first(where: { ($0.cash_flow_entries?.count ?? 0) >= 1 })
    return NavigationView {
        if account != nil {
            AccountTransactionsView(account: account!)
        }
    }
    .modelContainer(previewContainer)
    .environmentObject(journal)
}
