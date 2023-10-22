//
//  JournalDetailView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct JournalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.name) private var accounts: [Account]
    
    var journal: Journal
    
    @State private var exampleAccounts: [String] = [
        "Assets", "Liabilities", "Income", "Expenses", "Equity"
    ]
    @State private var exampleCurrencies: [String] = ["US Dollar", "Euro"]
    
    @State private var editMode: EditMode = .inactive
    
    
    var body: some View {
        List {
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
            .textCase(nil)
            
            Section(header: AccountsActionSheet()) {
                ForEach(accounts) { account in
                    DisclosureGroup(
                        content: {
                            ForEach(account.subAccounts, id: \.self) { subAccount in
                                NavigationLink(
                                    destination: TransactionPageView(title: subAccount),
                                    label: {
                                        Text(subAccount)
                                    })
                            }
                            .onDelete(perform: deleteAccounts)
                            .onMove(perform: {
                                account.subAccounts.move(fromOffsets: $0, toOffset: $1)
                            })
                        },
                        label: {
                            Text(account.name)
                                .fontWeight(.semibold)
                        }
                    )
                }
            }
            .textCase(nil)
            
            Section(header: CurrencyActionSheet()) {
                ForEach(exampleCurrencies, id: \.self) { currency in
                    NavigationLink(destination: TransactionPageView(title: currency), label: {
                        Text(currency)
                    })
                }
                .onDelete(perform: { offsets in
                    // TODO
                })
                .onMove(perform: { exampleCurrencies.move(fromOffsets: $0, toOffset: $1) } )
            }
            .textCase(nil)
        }
        .listStyle(.sidebar)
        .navigationTitle(journal.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
    }
    
    private func deleteAccounts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(accounts[index])
            }
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    
    let example = Journal(name: "Example")
    previewContainer.mainContext.insert(example)
    previewContainer.mainContext.insert(Account(name: "Account 1"))
    previewContainer.mainContext.insert(Account(name: "Account 2"))
    previewContainer.mainContext.insert(Account(name: "Account 3"))
    
    return NavigationView {
        JournalDetailView(journal: example)
            .modelContainer(previewContainer)
    }
}
