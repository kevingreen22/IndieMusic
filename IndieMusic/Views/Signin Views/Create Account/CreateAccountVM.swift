//
//  CreateAccountVM.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/4/21.
//

import SwiftUI

class CreateAccountVM: ObservableObject {    
    @Published var isSigningIn = false
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    
    func createAccount(completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password1.isEmpty, !password2.isEmpty, !name.isEmpty else { return }
        
        email = email.trimmingCharacters(in: .whitespaces)
        
        let newUser = User(name: name, email: email, profilePictureURL: nil, profilePictureData: nil, songListData: [], favoriteArtists: [], favoriteAlbums: [], favoriteSongs: [], recentlyAdded: [], artist: nil)
        
        AuthManager.shared.signUp(email: email, password: password1) { success in
            if success {
                DatabaseManger.shared.insert(user: newUser) { inserted in
                    guard inserted else { return }
                    UserDefaults.standard.setValue(self.email, forKey: "email")
                    UserDefaults.standard.setValue(self.name, forKey: "name")
                    
                    AuthManager.shared.signIn(email: self.email, password: self.password1) { success in
                        if success {
                            completion(true)
                        } else {
                            print("failied to sign-in after creating account.")
                            completion(false)
                        }
                    }
                }
            } else {
                print("failied to create account.")
                completion(false)
            }
            
        }
    }
    
}
