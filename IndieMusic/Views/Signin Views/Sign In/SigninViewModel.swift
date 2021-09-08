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
    @Published var showCreateAccount = false
    
    
    func signIn(completion: @escaping (Bool) -> Void) {
        isSigningIn.toggle()
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.isEmpty else { isSigningIn.toggle(); return }
        
        email = email.trimmingCharacters(in: .whitespaces)
        
        AuthManager.shared.signIn(email: email, password: password) { success in
            if success {
                UserDefaults.standard.setValue(self.email, forKey: "email")
                completion(true)
            } else {
                completion(false)
            }
            self.isSigningIn.toggle()
        }
    }
}
