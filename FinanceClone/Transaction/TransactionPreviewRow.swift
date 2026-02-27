//
//  TransactionPreviewRow.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import SwiftUI
import SwiftData

struct TransactionPreviewRow: View {
    let entry: TransactionEntry
    var displayAmount: Double? = nil
    var displayAmountCurrency: Currency? = nil
    var runningBalance: Double? = nil
    var runningBalanceCurrency: Currency? = nil
    var primaryAccount: Account? = nil

    @Environment(\.modelContext) private var modelContext

    private var note: String {
        entry.note.isEmpty ? "Entry" : entry.note
    }

    private var isIncomeTransaction: Bool {
        (entry.entries ?? []).contains(where: { $0.account?.category == .income })
    }

    private var lhsAccounts: [Account] {
        isIncomeTransaction ? entry.debitedAccounts : entry.creditedAccounts
    }

    private var rhsAccounts: [Account] {
        isIncomeTransaction ? entry.creditedAccounts : entry.debitedAccounts
    }

    private var amountValue: Double {
        if let displayAmount {
            return displayAmount
        }
        return isIncomeTransaction ? entry.amount : -entry.amount
    }

    private var amountCurrency: Currency {
        displayAmountCurrency
            ?? primaryAccount?.currency
            ?? entry.sortedEntries.first?.currency
            ?? entry.sortedEntries.first?.account?.currency
            ?? .USD
    }

    private var amountColor: Color {
        if amountValue > 0 {
            return .green
        }
        if amountValue < 0 {
            return .red
        }
        return .secondary
    }

    private var runningBalanceText: String? {
        guard let runningBalance else { return nil }
        return formatAmount(
            amount: runningBalance,
            currency: runningBalanceCurrency ?? primaryAccount?.currency ?? amountCurrency
        )
    }

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .foregroundStyle(entry.cleared ? Color.clear : Color.gray)
                .frame(width: 6, height: 6)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(note)
                        .font(.subheadline)
                        .lineLimit(1)

                    if !entry.payee.isEmpty {
                        Text("@\(entry.payee)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    Text(formatAmount(amount: amountValue, currency: amountCurrency))
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .monospacedDigit()
                        .foregroundStyle(amountColor)
                }

                HStack(spacing: 4) {
                    accountFlowView(accounts: lhsAccounts)

                    Image(systemName: isIncomeTransaction ? "arrow.left" : "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    accountFlowView(accounts: rhsAccounts)

                    Spacer()

                    if let runningBalanceText {
                        Text(runningBalanceText)
                            .font(.footnote)
                            .fontWeight(.regular)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .font(.caption)
            }
            .swipeActions(edge: .leading) {
                Button(entry.cleared ? "Uncleared" : "Cleared") {
                    entry.cleared.toggle()
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    modelContext.delete(entry)
                } label: {
                    Text("Delete")
                }
                .tint(.red)

                Button(action: {
                    duplicateTransaction()
                }, label: {
                    Text("Duplicate")
                })
                .tint(.gray)
            }
        }
        .padding(.vertical, 1)
    }

    private func duplicateTransaction() {
        let duplicated = TransactionEntry(
            date: entry.date ?? Date(),
            note: entry.note,
            payee: entry.payee,
            number: entry.number,
            cleared: entry.cleared,
            journal: entry.journal
        )

        if duplicated.journal == nil {
            duplicated.journal = (entry.entries ?? []).compactMap { $0.account?.journal }.first
        }

        modelContext.insert(duplicated)
        duplicated.entries = []

        for originalEntry in entry.entries ?? [] {
            let clonedEntry = CashFlowEntry(
                transactionRef: duplicated,
                account: originalEntry.account,
                amount: originalEntry.amount,
                currency: originalEntry.currency ?? originalEntry.account?.currency
            )
            duplicated.entries?.append(clonedEntry)
            modelContext.insert(clonedEntry)
        }

        if let journal = duplicated.journal {
            if journal.transactions == nil {
                journal.transactions = []
            }
            if !(journal.transactions?.contains(where: { $0.id == duplicated.id }) ?? false) {
                journal.transactions?.append(duplicated)
            }
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to duplicate transaction: \(error)")
        }
    }

    @ViewBuilder
    private func accountFlowView(accounts: [Account]) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(accounts.enumerated()), id: \.offset) { idx, account in
                Text(account.name)
                    .foregroundStyle(account.label?.color ?? .secondary)

                if idx < accounts.count - 1 {
                    Text(", ")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = Journal(name: "Test")
    journal.currencies.append(Currency.USD)
    previewContainer.mainContext.insert(journal)

    let checking = Account(name: "Checking", journal: journal, category: .asset)
    let salary = Account(name: "Salary", journal: journal, category: .income, label: .green)
    let credit = Account(name: "Credit Card", journal: journal, category: .liabilities)
    let utilities = Account(name: "Utilities", journal: journal, category: .expense, label: .yellow)

    let trans1 = addTransaction(container: previewContainer, from: salary, to: checking, amount: 5000, note: "Paycheck", payee: "Google", currency: Currency.USD)
    let trans2 = addTransaction(container: previewContainer, from: credit, to: utilities, amount: 94.2, note: "Electricity", payee: "Edison", currency: Currency.USD)
    trans2.cleared = false

    return NavigationView {
        List {
            TransactionPreviewRow(entry: trans1)
                .modelContainer(previewContainer)

            TransactionPreviewRow(entry: trans2)
                .modelContainer(previewContainer)
        }
        .listStyle(.plain)
    }
    .padding(.horizontal, 8)
}
