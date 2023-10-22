//
//  SettingsView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

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
    SettingsView()
}
