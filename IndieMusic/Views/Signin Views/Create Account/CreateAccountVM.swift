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
    @Published var password: String = ""
    
    
    func createAccount(completion: @escaping (Bool) -> Void) {
        isSigningIn.toggle()
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.isEmpty, !name.isEmpty else { isSigningIn.toggle(); return }
        
        email = email.trimmingCharacters(in: .whitespaces)
        
        let newUser = User(name: name, email: email, profilePictureURL: nil, profilePictureData: nil, songListData: [], favoriteArtists: nil, favoriteAlbums: nil, favoriteSongs: nil, recentlyAdded: nil, artist: nil)
        
        AuthManager.shared.signUp(email: email, password: password) { success in
            if success {
                DatabaseManger.shared.insert(user: newUser) { inserted in
                    guard inserted else { return }
                    UserDefaults.standard.setValue(self.email, forKey: "email")
                    UserDefaults.standard.setValue(self.name, forKey: "name")
                    
                    AuthManager.shared.signIn(email: self.email, password: self.password) { success in
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
            
            self.isSigningIn.toggle()
        }
    }
    
}
