//
//  EditTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/14/23.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    let txn: TransactionEntry
    
    @Environment(\.editMode) private var editMode
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State private var entries: [CashFlowEntry] = []
    @State private var date: Date = Date()
    @State private var notes = ""
    @State private var payee = ""
    @State private var number = ""
    @State private var cleared = true
    
    @State private var account: Account? = nil
    
//    @State private var amount = 0.0
    
    init(txn: TransactionEntry) {
        self.txn = txn
        self._date = State(initialValue: txn.date ?? Date())
        self._notes = State(initialValue: txn.note)
        self._payee = State(initialValue: txn.payee)
        self._number = State(initialValue: txn.number)
        self._cleared = State(initialValue: txn.cleared)
        self._entries = State(initialValue: txn.entries ?? [])
    }
    
    var hasValidData : Bool {
        self.entries.count >= 2 && self.entries.allSatisfy({$0.amount != 0})
    }
    
    func save() {
        txn.date = self.date
        txn.note = self.notes
        txn.payee = self.payee
        txn.number = self.number
        txn.cleared = self.cleared
        dismiss()
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Cash Flow Section
                
                Section(content: {
                    ForEach(entries, id: \.self) { entry in
                        HStack {
                            if entry.account != nil {
                                Image(systemName: entry.amount > 0 ?  "arrow.right.circle.fill" : "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(
                                        entry.account?.label != nil ? entry.account!.label!.color : .secondary
                                    )
                                
                                
                                NavigationLink(destination: {
                                    PickAccountView(selectedAccount: $account)
                                }, label: {
                                    Text(entry.account!.name)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2, reservesSpace: false)
                                })
                            } else {
                                Button(action: {
                                    // TODO
                                }, label: {
                                    Text("Select Account")
                                        .foregroundStyle(.blue)
                                })
                            }
                            
                            
                            Spacer()
                            
//                            TextField(value: $amount, format: .number, label: {
//                                Text("0.00")
//                            })
//                            .keyboardType(.numbersAndPunctuation)
//                            .multilineTextAlignment(.trailing)
                            
                            Text(entry.amount.formatted(.number.precision(.fractionLength(0...2))))
                            
                            if entry.currency != nil {
                                Text(entry.currency!.rawValue)
                                    .foregroundStyle(.secondary)
                                //                                    .overlay {
                                //                                        NavigationLink(destination: Text("PickCurrencyView"), label: {
                                //                                            EmptyView()
                                //                                        })
                                //                                        .opacity(0)
                                //                                    }
                            }
                        }
                        .fontWeight(.regular)
                    }
                }, footer: {
                    Button(action: {
                        entries.append(CashFlowEntry(transactionRef: txn, account: nil, amount: 0, currency: journal.currencies.isEmpty ? Currency.USD : journal.currencies[0]))
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.multicolor)
                            .shadow(radius: 2)
                            .padding(.vertical, 2)
                    })
                })
                
                // MARK: - Details Section
                Section {
                    DatePicker("Date", selection: $date)
                    
                    VStack(alignment: .leading) {
                        if !notes.isEmpty {
                            Text("Notes").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Notes", text: $notes)
                    }
                    
                    VStack(alignment: .leading) {
                        if !payee.isEmpty{
                            Text("Payee").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Payee", text: $payee)
                    }
                    
                    VStack(alignment: .leading) {
                        if !number.isEmpty{
                            Text("Number").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextField("Number", text: $number)
                    }
                }
                
                // MARK: - Toggles Section
                Section {
                    Toggle(isOn: $cleared, label: { Text("Cleared") })
                }
                
                // MARK: - Attachments
                Section {
                    Button(action: {
                        // TODO
                    }, label: {
                        Text("Add Attachment")
                            .foregroundStyle(.blue)
                    })
                }
            }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: {
                        save()
                    })
                    .disabled(!hasValidData)
                }
            }
        }
        .listStyle(.insetGrouped)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initJournal(name: "Test", currency: .USD, withTemplate: .personal, container: previewContainer)
    
    let checking = Account(name: "Checking", journal: journal, category: .asset)
    let salary = Account(name: "Salary", journal: journal, category: .income, label: .green)
    
    journal.accounts?.removeAll(where: {
        $0.name == checking.name || $0.name == salary.name
    })
    journal.accounts?.append(checking)
    journal.accounts?.append(salary)
    
    let trans = addTransaction(container: previewContainer, from: salary, to: checking, amount: 5000, note: "Paycheck", payee: "Google", currency: Currency.USD)
    trans.cleared = false
    
    return EditTransactionView(txn: trans).environmentObject(journal)}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initJournal(name: "Test", currency: .USD, withTemplate: .personal, container: previewContainer)
    
    let credit = Account(name: "Credit Card", journal: journal, category: .liabilities)
    let utilities = Account(name: "Utilities", journal: journal, category: .expense, label: .yellow)
    
    journal.accounts?.removeAll(where: {
        $0.name == credit.name || $0.name == utilities.name
    })
    journal.accounts?.append(credit)
    journal.accounts?.append(utilities)
    
    let trans = addTransaction(container: previewContainer, from: credit, to: utilities, amount: 94.223, note: "Electricity", payee: "Edison", currency: Currency.USD)
    
    return EditTransactionView(txn: trans).environmentObject(journal)
}

