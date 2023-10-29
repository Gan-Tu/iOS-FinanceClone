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
        Section(header: TransactionActionSheet().textCase(.none)) {
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
        Section(header: CurrencyActionSheet().textCase(.none)) {
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
    @Environment(\.editMode) private var editMode
    
    @State private var editAccount = false
    
    var body: some View {
        Section(header: AccountsActionSheet().textCase(.none)) {
            ForEach(AccountCategory.allCases, id: \.self) { category in
                DisclosureGroup(
                    content: {
                        ForEach(journal.accounts ?? []) { account in
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
                                        
                                        if editMode?.wrappedValue.isEditing != true {
                                            Button(action: { editAccount.toggle() }, label: {
                                                Image(systemName: "info.circle")
                                                    .foregroundStyle(Color.accentColor)
                                            })
                                        }
                                    }
                                }
                                .sheet(isPresented: $editAccount, content: {
                                    EditAccountView()
                                })
                            }
                        }
                        .onDelete(perform: {
                            journal.accounts!.remove(atOffsets: $0)
                        })
                        .onMove(perform: {
                            journal.accounts!.move(fromOffsets: $0, toOffset: $1)
                        })
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
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationView {
        JournalDetailView(journal: journal)
            .modelContainer(previewContainer)
    }
}
