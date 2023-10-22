//
//  JournalHomeView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct JournalHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Journal.name) private var journals: [Journal]
    
    @State private var isAddJournalSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(journals) { journal in
                    NavigationLink {
                        JournalDetailView(journal: journal)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "folder")
                                .foregroundStyle(Color.accentColor)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(journal.name)
                                Text("\(journal.numTransactions) Transactions")
                                    .font(.footnote)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteJournals)
            }
            .navigationTitle("Journals")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isAddJournalSheetPresented = true
                        // addJournal(name: "test")
                    }) {
                        Label("Add Journal", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $isAddJournalSheetPresented, content: {
            AddJournalSheetView()
        })
    }
    
    private func addJournal(name: String) {
        withAnimation {
            let newJournal = Journal(name: name)
            modelContext.insert(newJournal)
        }
    }
    
    private func deleteJournals(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(journals[index])
            }
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    previewContainer.mainContext.insert(Journal(name: "Journal 1"))
    previewContainer.mainContext.insert(Journal(name: "Journal 2", numTransactions: 10))
    previewContainer.mainContext.insert(Account(name: "Account 1"))
    previewContainer.mainContext.insert(Account(name: "Account 2"))
    previewContainer.mainContext.insert(Account(name: "Account 3"))
    
    return JournalHomeView().modelContainer(previewContainer)
}
