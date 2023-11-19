//
//  PickAccountView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/14/23.
//

import SwiftUI


import SwiftUI
import SwiftData

struct PickAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var journal: Journal
    
    @Binding var selectedAccount: Account?
    @State private var showCreateAccountSheet = false
    @State private var showChooseAccountType = false
    @State private var selectedCategory: AccountCategory? = nil
    
    var body: some View {
        Group {
            if journal.accounts == nil {
                Text("No accounts available")
            } else {
                List {
                    ForEach(AccountCategory.allCases, id: \.self) { cat in
                        Section(header: Text(cat.rawValue), content: {
                            ForEach(journal.accounts ?? [], id: \.self) { acc in
                                if acc.category == cat {
                                    Button(action: {
                                        selectedAccount = acc;
                                        dismiss();
                                    }, label: {
                                        HStack {
                                            if acc.label != nil {
                                                Circle()
                                                    .foregroundStyle(acc.label!.color)
                                                    .frame(height: 20)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(acc.name)
                                                
                                                if !acc.accountDescription.isEmpty {
                                                    Text(acc.accountDescription)
                                                        .multilineTextAlignment(.leading)
                                                        .font(.footnote)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Text(acc.currency.rawValue)
                                                .foregroundStyle(.secondary)
                                            
                                            if acc == selectedAccount {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(Color.accentColor)
                                            }
                                        }
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        })
                    }
                }
            }
        }
        .navigationBarTitle("Choose Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showChooseAccountType = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .confirmationDialog(
            "What kind of account doyou want to create?",
            isPresented: $showChooseAccountType,
            titleVisibility: .visible
        ) {
            ForEach(AccountCategory.allCases, id: \.self) { category in
                Button(category.rawValue) {
                    selectedCategory = category
                    showCreateAccountSheet = true
                }
            }
        }
        .sheet(isPresented: $showCreateAccountSheet) {
            if selectedCategory != nil {
                CreateAccountView(category: selectedCategory!)
                    .environmentObject(journal)
            } else {
                // Defensive coding
                Text("You need to select an account type")
            }
        }
    }
}

struct PickAccountViewPreview: View {
    @State var selectedAccount: Account? = nil
    
    var body: some View {
        NavigationStack {
            PickAccountView(selectedAccount: $selectedAccount)
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false);
    let journal = initPreviewJournal(container: previewContainer)
    return NavigationStack {
        PickAccountViewPreview()
            .modelContainer(previewContainer)
            .environmentObject(journal)
    }
}
