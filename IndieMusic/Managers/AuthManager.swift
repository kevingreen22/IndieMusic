//
//  AuthManager.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    /// Returns whether or not a user is signed in.
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    
    
    /// Creates a new user.
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    /// Signs a user in.
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    
    /// Signs a user out.
    func signOut(completion: (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            completion(false)
            print(error)
        }
    }
    
}
