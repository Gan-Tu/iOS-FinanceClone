//
//  JournalState.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import Foundation
import SwiftData

class JournalState: ObservableObject {
    @Published var journal: Journal
    
    init(journal: Journal) {
        self.journal = journal
    }
}
