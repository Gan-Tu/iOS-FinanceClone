//
//  CreateTransactionView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import SwiftUI

struct CreateTransactionView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Text("CreateTransactionView")
                .navigationBarTitle("New Transaction")
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
                            dismiss()
                        })
                        .disabled(true)
                    }
                }
        }
    }
}

#Preview {
    CreateTransactionView()
}
