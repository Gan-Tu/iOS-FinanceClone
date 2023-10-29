//
//  EditAccountView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI
import SwiftData

struct EditAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

//    let account: Account
    
    var body: some View {
        NavigationStack {
            Text("EditAccountView")
                .navigationBarTitle("Edit Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: {
                            dismiss()
                        })
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save", action: {
                            // TODO
                        })
                        // .disabled(name.isEmpty)
                    }
                }
        }
    }
}


#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer(seedData: false)
    let journal = seedJournal(container: previewContainer)
    initPersonalTemplate(container: previewContainer, journal: journal)
    return EditAccountView()
        .modelContainer(previewContainer)
        .environmentObject(journal)
}

