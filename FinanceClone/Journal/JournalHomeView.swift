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
    @Query(sort: [SortDescriptor(\Journal.creationTimestamp)]) private var journals: [Journal]
    
    @State private var isAddJournalSheetPresented: Bool = false
    @State private var currentJournal: Journal? = nil
    
    var body: some View {
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
                }) {
                    Label("Add Journal", systemImage: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $isAddJournalSheetPresented, content: {
            CreateJournalView()
        })
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
    let previewContainer: ModelContainer = createPreviewModelContainer()
    return NavigationStack{
        JournalHomeView().modelContainer(previewContainer)
    }
}
