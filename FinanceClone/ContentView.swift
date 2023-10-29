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
                    // TODO(tuagn): should update the text based on status
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
    let previewContainer: ModelContainer = createPreviewModelContainer()
    return ContentView().modelContainer(previewContainer)
}
