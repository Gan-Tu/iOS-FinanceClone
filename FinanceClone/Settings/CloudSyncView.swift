//
//  CloudSyncView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftUI
import SwiftData

struct CloudSyncView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    
    var showDoneButton: Bool = true
    
    @Environment(\.dismiss) var dismiss
    @State private var showResetActionSheet: Bool = false
    @State private var showSyncToast: Bool = false
    
    private var isCloudSyncEnabled: Bool { appState.isCloudSyncEnabled }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $appState.isCloudSyncEnabled, label: {
                            Text("Cloud Sync")
                                .font(.title)
                        })
                        .onChange(of: appState.isCloudSyncEnabled, initial: false) { _, _ in
                            showSyncToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                showSyncToast = false
                            }
                        }
                        
                        Text("Keep your data up-to-date between your iPhone, iPad, and Mac. Data is securely stored on iCloud.")
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Section(header: Text("Status")) {
                    if isCloudSyncEnabled {
                        Text("Up to date")
                    } else {
                        Text("Sync Disabled")
                    }
                }
                
                Section {
                    Button(action: {
                        showSyncToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showSyncToast = false
                        }
                    }, label: {
                        Text("Synchronize Now")
                            .if(!isCloudSyncEnabled) {
                                $0.foregroundStyle(Color.gray)
                            }
                            .if(isCloudSyncEnabled) {
                                $0.foregroundStyle(Color.blue)
                            }
                    })
                    .disabled(!isCloudSyncEnabled)
                    
                    Button(action: {
                        showResetActionSheet = true
                    }, label: {
                        Text("Reset...")
                            .if(isCloudSyncEnabled) {
                                $0.foregroundStyle(Color.gray)
                            }
                            .if(!isCloudSyncEnabled) {
                                $0.foregroundStyle(Color.blue)
                            }
                    })
                        .disabled(isCloudSyncEnabled)
                        .confirmationDialog(
                            "You are resetting your data.",
                            isPresented: $showResetActionSheet,
                            titleVisibility: .visible) {
                            Button("Reset All Data", role: .destructive) {
                                resetData()
                            }
                            Button("Reset Cloud Data", role: .destructive) {
                                resetData()
                            }
                            Button("Reset App Data", role: .destructive) {
                                resetData()
                            }
                        }
                    
                }
                .alert("Sync status updated.", isPresented: $showSyncToast) {}
            }
            .listStyle(.plain)
            .contentMargins(.horizontal, 12, for: .scrollContent)
            .contentMargins(.horizontal, 0, for: .scrollIndicators)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationBarTitle("Cloud Sync")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showDoneButton {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done", action: { dismiss() })
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Link(destination: URL(string: "https://tugan.me")!) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
    }
    
    func resetData() {
        do {
            try modelContext.delete(model: CashFlowEntry.self)
            try modelContext.delete(model: TransactionEntry.self)
            try modelContext.delete(model: Journal.self)
            try modelContext.delete(model: Account.self)
        } catch {
            print("Failed to clear all Journal and Account data.")
        }
    }
}

#Preview("Sheet") {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return CloudSyncView(showDoneButton: true)
        .modelContainer(previewContainer)
        .environmentObject(AppState())
}

#Preview("Navigation") {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return CloudSyncView(showDoneButton: true)
        .modelContainer(previewContainer)
        .environmentObject(AppState())
}
