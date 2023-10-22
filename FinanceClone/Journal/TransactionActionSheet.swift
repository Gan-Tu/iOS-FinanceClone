//
//  TransactionActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI

struct TransactionActionSheet: View {
    @State private var isOpen = false
    
    var body: some View {
        HStack {
            Text("TRANSACTIONS")
            
            Spacer()
            
            Button(action: { isOpen = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action", isPresented: $isOpen, titleVisibility: .hidden
            ) {
                Button("Create Transaction") {
                    // TODO
                }
                
                Button("Import...") {
                    // TODO
                }
                
                Button("Export...") {
                    // TODO
                }
            }
        }
    }
}

#Preview {
    TransactionActionSheet()
}
