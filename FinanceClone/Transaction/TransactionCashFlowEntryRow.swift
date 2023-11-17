//
//  TransactionCashFlowEntryRow.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/17/23.
//

import SwiftUI
import SwiftData

struct TransactionCashFlowEntryRow: View {
    @Binding var account: Account?
    @Binding var amount: Double
    @Binding var currency: Currency
    
    var body: some View {
        HStack {
            Group {
                if account != nil {
                    Image(systemName: amount > 0 ?  "arrow.right.circle.fill" : "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(
                            account?.label != nil ? account!.label!.color : .secondary
                        )
                    
                    
                    Text(account!.name)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2, reservesSpace: false)
                } else {
                    Text("Select Account")
                        .foregroundStyle(.blue)
                }
            }
            
            
            Spacer()
            
            //                            TextField(value: $amount, format: .number, label: {
            //                                Text("0.00")
            //                            })
            //                            .keyboardType(.numbersAndPunctuation)
            //                            .multilineTextAlignment(.trailing)
            
            Text(amount.formatted(.number.precision(.fractionLength(0...2))))
            
            Text(currency.rawValue).foregroundStyle(.secondary)
        } // HSTACK
        .fontWeight(.regular)
        .background {
            NavigationLink(destination: {
                PickAccountView(selectedAccount: $account)
            }, label: {
                EmptyView()
            })
            .opacity(0)
        }
    }
}

struct TransactionCashFlowEntryRowPreview: View {
    @State var entry = CashFlowEntryWrapper()
    
    var body: some View {
        NavigationView {
            List {
                TransactionCashFlowEntryRow(account: $entry.account, amount: $entry.amount, currency: $entry.currency)
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    return TransactionCashFlowEntryRowPreview()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
