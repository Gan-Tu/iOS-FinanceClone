//
//  TransactionPageView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI

struct TransactionPageView: View {
    var title: String
    
    var body: some View {
        Text("\(title) Transactions")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TransactionPageView(title: "Credit Card")
    }
}
