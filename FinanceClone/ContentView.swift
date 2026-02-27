//
//  ContentView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    @State private var isSettingsSheetPresented = false
    @State private var isCloudSyncSheetPresented = false
    @State private var isSearchSheetPresented = false
    @State private var isAddTransactionPickerPresented = false
    @State private var isAddTransactionSheetPresented = false

    @State private var selectedTemplate: TransactionTemplate = .transfer
    @State private var selectedSeedNote = ""

    var body: some View {
        NavigationStack {
            JournalHomeView()
        }
        .safeAreaInset(edge: .bottom) {
            bottomToolbar
        }
        .sheet(isPresented: $isSettingsSheetPresented) {
            SettingsView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $isCloudSyncSheetPresented) {
            CloudSyncView(showDoneButton: true)
                .environmentObject(appState)
        }
        .sheet(isPresented: $isAddTransactionSheetPresented) {
            if let journal = appState.currentJournal {
                CreateTransactionView(
                    template: selectedTemplate,
                    seedNote: selectedSeedNote
                )
                .environmentObject(journal)
            }
        }
        .sheet(isPresented: $isSearchSheetPresented) {
            if let journal = appState.currentJournal {
                SearchTransactionView()
                    .environmentObject(journal)
            }
        }
        .confirmationDialog(
            "You are creating a new transaction.",
            isPresented: $isAddTransactionPickerPresented,
            titleVisibility: .visible
        ) {
            Button("💵 收入 Income") {
                startTransactionCreation(template: .income)
            }

            Button("💰 支出 Expense") {
                startTransactionCreation(template: .expense)
            }

            Button("🏮 转账 Transfer") {
                startTransactionCreation(template: .transfer)
            }

            Button("🥡🍹 吃喝 Food & Drinks") {
                startTransactionCreation(template: .expense, seedNote: "Food & Drinks")
            }

            Button("🛍️ 购物 Shopping") {
                startTransactionCreation(template: .expense, seedNote: "Shopping")
            }

            Button("🚕 打车 Ride Share") {
                startTransactionCreation(template: .expense, seedNote: "Ride Share")
            }

            Button("🏦 Venmo") {
                startTransactionCreation(template: .transfer, seedNote: "Venmo")
            }

            Button("💳 信用卡还款 Credit Card Pymt") {
                startTransactionCreation(template: .transfer, seedNote: "Credit Card Payment")
            }

            Button("Customize...") {
                startTransactionCreation(template: .transfer)
            }
        }
    }

    private var bottomToolbar: some View {
        HStack {
            if appState.currentJournal != nil {
                Button(action: { isSearchSheetPresented = true }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
            } else {
                Button(action: { isSettingsSheetPresented = true }) {
                    Image(systemName: "gear")
                        .font(.title3)
                }
            }

            Spacer()

            Button(action: { isCloudSyncSheetPresented = true }) {
                Text(appState.isCloudSyncEnabled ? "Up to date" : "Sync Disabled")
                    .font(.headline)
            }
            .buttonStyle(.plain)

            Spacer()

            if appState.currentJournal != nil {
                Button(action: {
                    isAddTransactionPickerPresented = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title3)
                }
            } else {
                Color.clear.frame(width: 18, height: 18)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    private func startTransactionCreation(template: TransactionTemplate, seedNote: String = "") {
        selectedTemplate = template
        selectedSeedNote = seedNote
        isAddTransactionSheetPresented = true
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer()
    return ContentView()
        .modelContainer(previewContainer)
        .environmentObject(AppState())
}
