//
//  JournalDetailView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct JournalDetailView: View {
    var journal: Journal
    
    var body: some View {
        List {
            TransactionSectionView()
            AccountSection()
            CurrencySection()
        }
        .listStyle(.sidebar)
        .navigationTitle(journal.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton())
        .environmentObject(journal)
        
    }
}


struct TransactionSectionView: View {
    var body: some View {
        Section(header: TransactionActionSheet()) {
            NavigationLink(destination: TransactionPageView(title: "All"), label: {
                Image(systemName: "arrow.right")
                    .foregroundStyle(.accent)
                Text("All")
            })
            
            NavigationLink(destination: TransactionPageView(title: "Uncleared"), label: {
                Image(systemName: "circle")
                    .foregroundStyle(.accent)
                Text("Uncleared")
            })
            
            NavigationLink(destination: TransactionPageView(title: "Repeating"), label: {
                Image(systemName: "arrow.2.squarepath")
                    .foregroundStyle(.accent)
                Text("Repeating")
            })
        }
    }
}


struct CurrencySection: View {
    @EnvironmentObject var journal: Journal
    
    var body: some View {
        Section(header: CurrencyActionSheet()) {
            ForEach(journal.currencies, id: \.self) { currency in
                NavigationLink(
                    destination: TransactionPageView(title: currency.name),
                    label: { Text(currency.name) })
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
    @Query(sort: \Account.name) private var accounts: [Account]
    
    @State private var editAccount = false
    
    var body: some View {
        Section(header: AccountsActionSheet()) {
            ForEach(AccountCategory.allCases, id: \.self) { category in
                DisclosureGroup(
                    content: {
                        ForEach(accounts) { account in
                            if account.category == category {
                                Group {
                                    HStack {
//                                        NavigationLink(destination: {
//                                            TransactionPageView(title: account.name)
//                                        }, label: {
//                                            Text(account.name)
//                                        })
                                        Text(account.name)
                                        Spacer()
                                        Button(action: { editAccount.toggle() }, label: {
                                            Image(systemName: "info.circle")
                                                .foregroundStyle(Color.accentColor)
                                        })
                                    }
                                }
                                .sheet(isPresented: $editAccount, content: {
                                    EditAccountView(account: account)
                                })
                            }
                        }
                        .onDelete(perform: { offsets in
                            withAnimation {
                                for index in offsets {
                                    modelContext.delete(accounts[index])
                                }
                            }
                        })
                        // TODO(tugan): add onMove
                    },
                    label: {
                        Text(category.rawValue).fontWeight(.semibold)
                    }
                )
            }
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    
    let example = Journal(name: "Example")
    previewContainer.mainContext.insert(example)
    previewContainer.mainContext.insert(Account(name: "Checking", category: .asset))
    previewContainer.mainContext.insert(Account(name: "Cash", category: .asset))
    previewContainer.mainContext.insert(Account(name: "Credit Card", category: .liabilities))
    previewContainer.mainContext.insert(Account(name: "Salary", category: .income))
    previewContainer.mainContext.insert(Account(name: "Household", category: .expense))
    previewContainer.mainContext.insert(Account(name: "Opening Balance", category: .equity))
    
    return NavigationView {
        JournalDetailView(journal: example)
            .modelContainer(previewContainer)
    }
}
