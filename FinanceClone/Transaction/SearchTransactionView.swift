//
//  SearchTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/18/23.
//

import SwiftUI
import SwiftData

struct SearchTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var journal: Journal
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    List {
                        Section(header: Text("Suggestions")) {
                            HStack {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text("All Transactions")
                            }
                            HStack {
                                Image(systemName: "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text("Uncleared Transactions")
                            }
                            HStack {
                                Image(systemName: "arrow.2.squarepath")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text("Repeating Transactions")
                            }
                        }
                        
                        Section(header: Text("Date")) {
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text("Today")
                            }
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                Text("Last Month")
                            }
                        }
                    }
                    .listStyle(.inset)
                } else {
                    Text("Results for \(searchText)")
                }
            }
                .navigationBarTitle("Quick Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Done")
                        })
                    }
                }
        }
        .searchable(text: $searchText, prompt: "Search")
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = initPreviewJournal(container: previewContainer, seedTransactions: false)
    return SearchTransactionView()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}
