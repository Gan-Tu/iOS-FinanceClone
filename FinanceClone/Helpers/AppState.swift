//
//  AppState.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import Foundation
import LocalAuthentication

class AppState: ObservableObject {
    @Published var isCloudSyncEnabled: Bool = false
    @Published var isAuthenticated: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock the app for security purposes."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                }
            }
        } else {
            self.isAuthenticated = false
        }
    }
}
