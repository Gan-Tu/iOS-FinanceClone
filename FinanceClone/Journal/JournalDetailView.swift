//
//  JournalDetailView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

private extension AccountCategory {
    var displayName: String {
        switch self {
        case .asset: return "资产 Assets"
        case .liabilities: return "负债 Liabilities"
        case .income: return "收入 Income"
        case .expense: return "支出 Expenses"
        case .equity: return "股权 Equity"
        }
    }
}

struct JournalDetailView: View {
    var journal: Journal
    @EnvironmentObject var appState: AppState

    var body: some View {
        List {
            TransactionSectionView(journal: journal)
            AccountSection()
            CurrencySection()
        }
        .environmentObject(journal)
        .listStyle(.plain)
        .contentMargins(.horizontal, 8, for: .scrollContent)
        .contentMargins(.horizontal, 0, for: .scrollIndicators)
        .environment(\.defaultMinListRowHeight, 40)
        .listRowSpacing(0)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(journal.name)
                    .font(.subheadline)
                    .fontWeight(.regular)
            }

            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            appState.currentJournal = journal
        }
    }
}

struct TransactionSectionView: View {
    let journal: Journal
    
    private var unclearedCount: Int {
        if let transactions = journal.transactions {
            return transactions.filter({ !$0.cleared }).count
        }
        var ids = Set<String>()
        var count = 0
        for account in journal.accounts ?? [] {
            for flow in account.cash_flow_entries ?? [] {
                guard let txn = flow.transactionRef else { continue }
                if !txn.cleared && !ids.contains(txn.id) {
                    ids.insert(txn.id)
                    count += 1
                }
            }
        }
        return count
    }

    var body: some View {
        Section(header: TransactionActionSheet().textCase(.none)) {
            NavigationLink(destination: TransactionPageView(filter: .all, journal: journal), label: {
                Image(systemName: "arrow.right")
                    .foregroundStyle(.accent)
                    .font(.subheadline)
                Text("All")
                    .font(.subheadline)
            })
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(sectionRowBackground(index: 0, total: 3, radius: 14))

            NavigationLink(destination: TransactionPageView(filter: .uncleared, journal: journal), label: {
                Image(systemName: "circle")
                    .foregroundStyle(.accent)
                    .font(.subheadline)
                Text("Uncleared")
                    .font(.subheadline)
                Spacer()
                if unclearedCount > 0 {
                    Text("\(unclearedCount)")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            })
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(sectionRowBackground(index: 1, total: 3, radius: 14))

            NavigationLink(destination: TransactionPageView(filter: .repeating, journal: journal), label: {
                Image(systemName: "arrow.2.squarepath")
                    .foregroundStyle(.accent)
                    .font(.subheadline)
                Text("Repeating")
                    .font(.subheadline)
            })
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(sectionRowBackground(index: 2, total: 3, radius: 14))
        }
    }
}

struct CurrencySection: View {
    @EnvironmentObject var journal: Journal

    var body: some View {
        Section(header: CurrencyActionSheet().textCase(.none)) {
            ForEach(journal.currencies, id: \.self) { currency in
                Text(currency.name)
                    .font(.subheadline)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .onDelete(perform: {
                journal.currencies.remove(atOffsets: $0)
            })
            .onMove(perform: {
                journal.currencies.move(fromOffsets: $0, toOffset: $1)
            })
        }
    }
}

struct AccountSection: View {
    @EnvironmentObject var journal: Journal
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode

    @State private var accountToEdit: Account?
    @State private var expandedCategories: Set<AccountCategory> = []

    var body: some View {
        Section(header: AccountsActionSheet().textCase(.none)) {
            let categories = AccountCategory.allCases
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                DisclosureGroup(isExpanded: isExpandedBinding(for: category)) {
                    ForEach(accounts(for: category)) { account in
                        row(for: account)
                    }
                    .onMove { source, destination in
                        moveAccounts(in: category, from: source, to: destination)
                    }
                } label: {
                    HStack {
                        Text(category.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(categoryTotal(for: category))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .listRowBackground(sectionRowBackground(index: index, total: categories.count, radius: 14))
            }
        }
        .sheet(item: $accountToEdit, content: { account in
            EditAccountView(account: account)
                .environmentObject(journal)
        })
    }

    @ViewBuilder
    private func row(for account: Account) -> some View {
        if editMode?.wrappedValue.isEditing == true {
                HStack {
                    accountIndicator(for: account)

                    Text(account.name)
                        .font(.subheadline)
                    Spacer()
                    Text(account.describeBalance())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button(action: {
                        accountToEdit = account
                }, label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.accentColor)
                })
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
        } else {
            NavigationLink(destination: AccountTransactionsView(account: account).environmentObject(journal)) {
                HStack {
                    accountIndicator(for: account)

                    Text(account.name)
                        .font(.subheadline)
                    Spacer()
                    Text(account.describeBalance())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    modelContext.delete(account)
                } label: {
                    Text("Delete")
                }
            }
        }
    }

    @ViewBuilder
    private func accountIndicator(for account: Account) -> some View {
        Circle()
            .foregroundStyle(account.label?.color ?? .clear)
            .frame(width: 10, height: 10)
    }

    private func accounts(for category: AccountCategory) -> [Account] {
        (journal.accounts ?? [])
            .filter { $0.category == category }
    }

    private func moveAccounts(
        in category: AccountCategory,
        from source: IndexSet,
        to destination: Int
    ) {
        guard var allAccounts = journal.accounts else { return }

        var categoryAccounts = allAccounts.filter { $0.category == category }
        categoryAccounts.move(fromOffsets: source, toOffset: destination)

        var nextCategoryAccount = 0
        for index in allAccounts.indices {
            if allAccounts[index].category == category {
                allAccounts[index] = categoryAccounts[nextCategoryAccount]
                nextCategoryAccount += 1
            }
        }

        journal.accounts = allAccounts
    }

    private func isExpandedBinding(for category: AccountCategory) -> Binding<Bool> {
        Binding(
            get: { expandedCategories.contains(category) },
            set: { shouldExpand in
                if shouldExpand {
                    expandedCategories.insert(category)
                } else {
                    expandedCategories.remove(category)
                }
            }
        )
    }

    private func categoryTotal(for category: AccountCategory) -> String {
        let total = accounts(for: category).reduce(0) { partial, account in
            partial + account.balance
        }
        return formatAmount(amount: total, currency: journal.defaultCurreny)
    }
}

private func sectionRowBackground(index: Int, total: Int, radius: CGFloat) -> some View {
    let topRadius = index == 0 ? radius : 0
    let bottomRadius = index == total - 1 ? radius : 0

    return UnevenRoundedRectangle(
        cornerRadii: .init(
            topLeading: topRadius,
            bottomLeading: bottomRadius,
            bottomTrailing: bottomRadius,
            topTrailing: topRadius
        ),
        style: .continuous
    )
        .fill(Color(uiColor: .systemBackground))
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationView {
        JournalDetailView(journal: journal)
            .modelContainer(previewContainer)
            .environmentObject(AppState())
    }
}
