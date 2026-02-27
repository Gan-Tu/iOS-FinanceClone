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
    @EnvironmentObject var appState: AppState

    @Query(sort: [SortDescriptor(\Journal.creationTimestamp)]) private var journals: [Journal]
    @State private var isAddJournalSheetPresented: Bool = false
    
    var body: some View {
        List {
            Section {
                ForEach(Array(journals.enumerated()), id: \.element.id) { index, journal in
                    NavigationLink {
                        JournalDetailView(journal: journal)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "folder")
                                .foregroundStyle(Color.accentColor)
                                .font(.subheadline)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(journal.name)
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                Text("\(journal.numTransactions) Transactions")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .padding(.vertical, 1)
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .listRowBackground(journalRowBackground(index: index, total: journals.count))
                }
                .onDelete(perform: deleteJournals)
            }
        }
        .environment(\.defaultMinListRowHeight, 40)
        .listRowSpacing(0)
        .listStyle(.plain)
        .contentMargins(.horizontal, 8, for: .scrollContent)
        .contentMargins(.horizontal, 0, for: .scrollIndicators)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .environmentObject(appState)
        .onAppear {
            appState.currentJournal = nil
        }
        .navigationTitle("Journals")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isAddJournalSheetPresented = true
                }) {
                    Image(systemName: "plus")
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

    @ViewBuilder
    private func journalRowBackground(index: Int, total: Int) -> some View {
        let cornerRadius: CGFloat = 8
        let topRadius = index == 0 ? cornerRadius : 0
        let bottomRadius = index == total - 1 ? cornerRadius : 0

        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: topRadius,
                bottomLeading: bottomRadius,
                bottomTrailing: bottomRadius,
                topTrailing: topRadius
            ),
            style: .continuous
        )
        .fill(Color(uiColor: .systemBackground))
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer()
    NavigationStack{
        JournalHomeView()
            .modelContainer(previewContainer)
            .environmentObject(AppState())
    }
}
