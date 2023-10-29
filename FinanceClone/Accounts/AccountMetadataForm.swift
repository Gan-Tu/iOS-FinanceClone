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
        }
    }
}

#Preview {
    @State var name = ""
    @State var description = ""
    @State var category = AccountCategory.asset
    @State var currency: Currency? = Currency.USD

    return AccountMetadataForm(
        name: $name,
        description: $description,
        category: $category,
        accountCurrency: $currency)
}
