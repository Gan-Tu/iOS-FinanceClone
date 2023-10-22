//
//  AccountsActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI

struct AccountsActionSheet: View {
    @State private var isOpen = false
    
    var body: some View {
        HStack {
            Text("ACCOUNTS")
            
            Spacer()
            
            Button(action: { isOpen = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action", isPresented: $isOpen, titleVisibility: .hidden
            ) {
                Button("Create Account") {
                    // TODO
                }
            }
            .textCase(nil)
        }
    }
}

#Preview {
    AccountsActionSheet()
}
