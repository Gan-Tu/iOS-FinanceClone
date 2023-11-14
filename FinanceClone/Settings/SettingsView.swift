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
    
    @MainActor func seedData() {
        initJournal(name: "Personal", currency: .USD, withTemplate: .personal, container: modelContext.container)
        initJournal(name: "Business", currency: .USD, withTemplate: .business, container: modelContext.container)
        showSeedDataAlert = true
    }
    
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
                            seedData()
                        }
                        .alert("Fake data loaded successfully.", isPresented: $showSeedDataAlert, actions: {
                            // no actions
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

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer()
    return SettingsView().modelContainer(previewContainer).environmentObject(AppState())
}
