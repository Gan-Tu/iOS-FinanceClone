//
//  CurrencyActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI

struct CurrencyActionSheet: View {
    @State private var isOpen = false
    
    var body: some View {
        HStack {
            Text("CURRENCIES")
            
            Spacer()
            
            Button(action: { isOpen = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action", isPresented: $isOpen, titleVisibility: .hidden
            ) {
                Button("Add Curency") {
                    // TODO
                }
            }
            .textCase(nil)
        }
    }
}

#Preview {
    CurrencyActionSheet()
}
