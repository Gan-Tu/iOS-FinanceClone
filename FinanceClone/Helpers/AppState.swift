//
//  AppState.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/29/23.
//

import Foundation
import LocalAuthentication

class AppState: ObservableObject {
    static let cloudSyncPreferenceKey = "cloudSyncEnabled"

    @Published var isCloudSyncEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isCloudSyncEnabled, forKey: Self.cloudSyncPreferenceKey)
        }
    }
    @Published var isAuthenticated: Bool = false
    @Published var currentJournal: Journal? = nil

    init() {
        if UserDefaults.standard.object(forKey: Self.cloudSyncPreferenceKey) == nil {
            UserDefaults.standard.set(true, forKey: Self.cloudSyncPreferenceKey)
        }
        self.isCloudSyncEnabled = UserDefaults.standard.bool(forKey: Self.cloudSyncPreferenceKey)
    }
    
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
