//
//  ContentView.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/21/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var isSettingsSheetPresented: Bool = false
    @State private var isCloudSyncSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            JournalHomeView()

            Spacer()
            
            HStack {
                Button(action: { isSettingsSheetPresented = true }, label: {
                    Image(systemName: "gear")
                        .foregroundColor(.accent)
                        .font(.title2)
                })
                
                Spacer()
                
                Button(action: { isCloudSyncSheetPresented = true }, label: {
                    Text("Update to date")
                })
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .sheet(isPresented: $isSettingsSheetPresented, content: { SettingsView() })
            .sheet(isPresented: $isCloudSyncSheetPresented, content: { CloudSyncView(showDoneButton: true) })
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = createPreviewModelContainer();
    previewContainer.mainContext.insert(Journal(name: "Journal 1", numTransactions: 5))
    previewContainer.mainContext.insert(Journal(name: "Journal 2", numTransactions: 10))
    previewContainer.mainContext.insert(Account(name: "Account 1"))
    previewContainer.mainContext.insert(Account(name: "Account 2"))
    previewContainer.mainContext.insert(Account(name: "Account 3"))
    return ContentView().modelContainer(previewContainer)
}
