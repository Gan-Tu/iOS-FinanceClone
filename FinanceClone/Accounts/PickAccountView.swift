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
    
    var body: some View {
        NavigationStack {
            Group {
                if journal.accounts != nil {
                    List {
                        ForEach(AccountCategory.allCases, id: \.self) { cat in
                            Section(header: Text(cat.rawValue), content: {
                                ForEach(journal.accounts!, id: \.self) { acc in
                                    if acc.category == cat {
                                        HStack {
                                            
                                            if acc.label != nil {
                                                Circle()
                                                    .foregroundStyle(acc.label!.color)
                                                    .frame(height: 20)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(acc.name)
                                                    .onTapGesture(perform: {
                                                        selectedAccount = acc;
                                                        dismiss();
                                                })
                                                
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
                                    }
                                }
                            })
                        }
                    }
                } else {
                    Text("No accounts available")
                }
            }
            .navigationBarTitle("Choose Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showCreateAccountSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $showCreateAccountSheet) {
                Text("Create Account View")
            }
        }
    }
}

#Preview {
    @State var selectedAccount: Account?
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false);
    let journal = initPreviewJournal(container: previewContainer)
    return PickAccountView(selectedAccount: $selectedAccount)
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
