//
//  AccountsActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct AccountsActionSheet: View {
    @EnvironmentObject var journal: Journal
    
    @State private var showActionSheet = false
    @State private var chooseAccountType = false
    @State private var openCreateAccountSheet = false
    
    @State private var selectedCategroy: AccountCategory = .asset
    
    var body: some View {
        HStack {
            Text("ACCOUNTS")
            
            Spacer()
            
            Button(action: { showActionSheet = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action",
                isPresented: $showActionSheet,
                titleVisibility: .hidden
            ) {
                Button("Create Account") {
                    chooseAccountType = true
                }
            }
            .confirmationDialog(
                "What kind of account do you want to create?",
                isPresented: $chooseAccountType,
                titleVisibility: .visible
            ) {
                ForEach(AccountCategory.allCases, id: \.self) { category in
                    Button(category.rawValue) {
                        selectedCategroy = category
                        openCreateAccountSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $openCreateAccountSheet, content: {
            CreateAccountView(category: selectedCategroy)
        })
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = seedJournal(container: previewContainer)
    initPersonalTemplate(container: previewContainer, journal: journal)
    return AccountsActionSheet()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
