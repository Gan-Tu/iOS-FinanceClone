//
//  AccountsActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData

struct AccountsActionSheet: View {
    @State private var showActionSheet = false
    @State private var openCreateAccountSheet = false
    
    var body: some View {
        HStack {
            Text("ACCOUNTS")
            
            Spacer()
            
            Button(action: { showActionSheet = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action", isPresented: $showActionSheet, titleVisibility: .hidden
            ) {
                Button("Create Account") {
                    openCreateAccountSheet = true
                }
            }
        }
        .sheet(isPresented: $openCreateAccountSheet, content: {
            CreateAccountView()
        })
        .textCase(nil)
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    return AccountsActionSheet().modelContainer(previewContainer)
}
