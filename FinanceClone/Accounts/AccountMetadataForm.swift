//
//  AccountMetadataForm.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI
import SwiftData

struct AccountMetadataForm: View {
    @Binding var name: String
    @Binding var description: String
    @Binding var category: AccountCategory
    @Binding var accountCurrency: Currency?
    @Binding var accountLabel: AccountLabel?
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            
            Section {
                Picker(selection: $category, content: {
                    ForEach(AccountCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }, label: {
                    Text("Group In")
                        .foregroundStyle(Color.primary)
                })
                .pickerStyle(.navigationLink)
                
                NavigationLink(destination: {
                    PickCurrencyView(selectedCurrency: $accountCurrency)
                }, label: {
                    HStack {
                        Text("Currency")
                            .foregroundStyle(Color.primary)
                        
                        Spacer()
                        
                        if accountCurrency != nil {
                            Text(accountCurrency!.name)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                })
            }
            
            if category == .income || category == .expense {
                Section {
                    ForEach(AccountLabel.allCases, id: \.self) { labelOption in
                        Button(action: {
                            accountLabel = labelOption
                        }, label: {
                            HStack {
                                Circle()
                                    .foregroundStyle(labelOption.color)
                                    .frame(height: 20)

                                Text("\(labelOption.rawValue)")

                                if accountLabel == labelOption {
                                    Spacer()

                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        })
                        .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .listStyle(.plain)
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .contentMargins(.horizontal, 0, for: .scrollIndicators)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

private struct AccountMetadataFormAssetPreview: View {
    @State var name = ""
    @State var description = ""
    @State var category = AccountCategory.asset
    @State var currency: Currency? = Currency.USD
    @State var accountLabel: AccountLabel? = nil
    private let previewContainer: ModelContainer
    private let journal: Journal

    init() {
        let container = createPreviewModelContainer(seedData: false)
        self.previewContainer = container
        self.journal = initPreviewJournal(container: container, seedTransactions: false)
    }

    var body: some View {
        NavigationStack {
            AccountMetadataForm(
                name: $name,
                description: $description,
                category: $category,
                accountCurrency: $currency,
                accountLabel: $accountLabel
            )
            .environmentObject(journal)
        }
        .modelContainer(previewContainer)
    }
}

private struct AccountMetadataFormIncomePreview: View {
    @State var name = "Income"
    @State var description = ""
    @State var category = AccountCategory.income
    @State var currency: Currency? = Currency.GBP
    @State var accountLabel: AccountLabel? = .green
    private let previewContainer: ModelContainer
    private let journal: Journal

    init() {
        let container = createPreviewModelContainer(seedData: false)
        self.previewContainer = container
        self.journal = initPreviewJournal(container: container, seedTransactions: false)
    }

    var body: some View {
        NavigationStack {
            AccountMetadataForm(
                name: $name,
                description: $description,
                category: $category,
                accountCurrency: $currency,
                accountLabel: $accountLabel
            )
            .environmentObject(journal)
        }
        .modelContainer(previewContainer)
    }
}

#Preview("Asset") {
    AccountMetadataFormAssetPreview()
}

#Preview("Income") {
    AccountMetadataFormIncomePreview()
}
