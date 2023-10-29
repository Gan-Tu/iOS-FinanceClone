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
    @Binding var label: AccountLabel?
    
    var body: some View {
        Form {
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
                        HStack {
                            Circle()
                                .foregroundStyle(labelOption.color)
                                .frame(height: 20)
                            Text("\(labelOption.rawValue)")

                            if label == labelOption {
                                Spacer()

                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .onTapGesture {
                            label = labelOption
                        }
                    }
                }
            }
        }
    }
}

#Preview("Asset") {
    @State var name = ""
    @State var description = ""
    @State var category = AccountCategory.asset
    @State var currency: Currency? = Currency.USD
    @State var label: AccountLabel? = nil

    return AccountMetadataForm(
        name: $name,
        description: $description,
        category: $category,
        accountCurrency: $currency,
        label: $label)
}

#Preview("Income") {
    @State var name = "Income"
    @State var description = ""
    @State var category = AccountCategory.income
    @State var currency: Currency? = Currency.GBP
    @State var label: AccountLabel? = .green

    return AccountMetadataForm(
        name: $name,
        description: $description,
        category: $category,
        accountCurrency: $currency,
        label: $label)
}
