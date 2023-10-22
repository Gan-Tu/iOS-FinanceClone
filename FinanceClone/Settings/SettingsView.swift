//
//  SettingsView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showSeedDataAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: {
                        CloudSyncView(showDoneButton: false)
                    }, label: {
                        CustomListRowView(rowLabel: "Cloud Sync", rowIcon: "cloud", rowTintColor: .blue)
                    })
                    
                    NavigationLink(destination: {
                        Text("Security View")
                            .navigationTitle("Security")
                    }, label: {
                        CustomListRowView(rowLabel: "Security", rowIcon: "lock.shield", rowTintColor: .red)
                    })
                }
                
                Section {
                    CustomListRowView(rowLabel: "Load Fake Data", rowIcon: "doc", rowTintColor: .yellow)
                        .onTapGesture {
                            modelContext.insert(Journal(name: "Journal 1", numTransactions: 5))
                            modelContext.insert(Journal(name: "Journal 2", numTransactions: 10))
                            modelContext.insert(Account(name: "Account 1"))
                            modelContext.insert(Account(name: "Account 2"))
                            modelContext.insert(Account(name: "Account 3"))
                            showSeedDataAlert = true
                        }
                        .alert("Fake data loaded successfully.", isPresented: $showSeedDataAlert, actions: {
                            // TODO
                        })
                    
                    NavigationLink(destination: {
                        Text("Backup View")
                            .navigationTitle("Backup")
                    }, label: {
                        CustomListRowView(rowLabel: "Backup", rowIcon: "archivebox", rowTintColor: .green)
                    })
                }
                
                Section {
                    CustomListRowView(rowLabel: "Finances for Mac", rowIcon: "laptopcomputer", rowTintColor: .green)
                    CustomListRowView(rowLabel: "Rate Finances", rowIcon: "heart", rowTintColor: .pink)
                    CustomListRowView(rowLabel: "Help", rowIcon: "questionmark", rowTintColor: .cyan)
                }
                
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done", action: { dismiss() })
                }
            }
        }
    }
}

//footer: HStack {
//    Spacer()
//    Text("Copyright © All rights reserved")
//    Spacer()
//}.padding(.vertical, 8)

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return SettingsView().modelContainer(previewContainer)
}
