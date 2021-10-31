//
//  SigninViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/4/21.
//

import SwiftUI
import FirebaseAuth

class SigninViewModel: ObservableObject {    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSigningIn: Bool = false
    @Published var activeFullScreen: ActiveFullScreen?
    @Published var alertItem: MyAlertItem?
    
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.isEmpty else {
            completion(false)
            return
        }
        
        email = email.trimmingCharacters(in: .whitespaces)
        
        AuthManager.shared.signIn(email: email, password: password) { success in
            if success {
                UserDefaults.standard.setValue(self.email, forKey: "email")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
