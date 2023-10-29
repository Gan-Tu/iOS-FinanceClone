//
//  CurrencyActionSheet.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI

struct CurrencyActionSheet: View {
    @State private var showChoices = false
    @State private var showCurrencySelector = false
    
    var body: some View {
        HStack {
            Text("CURRENCIES")
            
            Spacer()
            
            Button(action: { showChoices = true }) {
                Image(systemName: "ellipsis")
            }
            .confirmationDialog(
                "Select a action",
                isPresented: $showChoices,
                titleVisibility: .hidden
            ) {
                Button("Add Curency") {
                    showCurrencySelector = true
                }
            }
            .sheet(isPresented: $showCurrencySelector) {
                CurrencySelectorView(showCancelButton: true) { currency in
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
