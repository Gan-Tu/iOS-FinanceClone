//
//  ModelContainer.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/22/23.
//

import SwiftData


let schema = Schema([
    Item.self,
    Journal.self,
    Account.self,
])

func createMainModelContainer() -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}


func createPreviewModelContainer() -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}

