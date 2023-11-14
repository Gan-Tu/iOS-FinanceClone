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
    @State private var showSyncAlert: Bool = false
    @State private var showResetActionSheet: Bool = false
    
    private var isCloudSyncEnabled: Bool {
        return appState.isCloudSyncEnabled
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $appState.isCloudSyncEnabled, label: {
                            Text("Cloud Sync")
                                .font(.title)
                        })
                        .onChange(of: isCloudSyncEnabled, initial: false, {
                            showSyncAlert = true
                            // Automatically dismiss after 1 second
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.showSyncAlert = false
                            }
                        })
                        
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
                        // TODO
                    }, label: {
                        Text("Sync Now")
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
                .alert(isCloudSyncEnabled ? "Enabling Sync..." : "Disabling Sync...", isPresented: $showSyncAlert) {
                    Button("Cancel", role: .cancel) {
                        // TODO
                    }
                }
            }
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
    @State var isSyncEnabled = false
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return CloudSyncView(showDoneButton: true)
        .modelContainer(previewContainer)
        .environmentObject(AppState())
}
