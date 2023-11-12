//
//  Transaction.swift
//  FinanceClone
//
//  Created by Gan Tu on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: String = UUID().uuidString
        
//    @Relationship(deleteRule: .cascade, inverse: \CashFlowEntry.transactionRef)
//    var entries: [CashFlowEntry]? = []
//    
    var date: Date? = nil
    var note: String = ""
    var payee: String = ""
    var number: String = ""
    var cleared: Bool = true
    
    // TODO(tugan): add attachments
    
    init(date: Date) {
        self.date = date
    }
}

