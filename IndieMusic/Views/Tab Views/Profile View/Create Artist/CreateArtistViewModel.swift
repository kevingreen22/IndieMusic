//
//  CreateArtistViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateArtistViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var addAlbum = false
    @Published var artistName = ""
    @Published var album = ""
    @Published var bio = ""
    @Published var genre = ""
    @Published var newGenreName = ""
    @Published var bioImage: UIImage? = nil
    @Published var pickImage: Bool? = false
    
    
    
    func createArtist(viewModel: ViewModel) {
        // Validate info
        guard artistName != "",
              genre != "" else {
            print("Required Song info not completed.")
            viewModel.alertItem = MyStandardAlertContext.infoIncomplete
            return
        }
              
        let ownerArtist = Artist(name: artistName, genre: genre, imageURL: nil, albums: nil)
        DatabaseManger.shared.insert(artist: ownerArtist) { success in
            if success {
                print("New owner artist inserted into DB.")
                
                viewModel.user.artist = ownerArtist
                DatabaseManger.shared.insert(user: viewModel.user) { success in
                    if success {
                        print("User model updated.")
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Error updating user model witn new artist.")
                        self.reverseCreateArtistIfError(viewModel: viewModel)
                        viewModel.alertItem = MyStandardAlertContext.createOwnerArtistFailed
                    }
                }
            } else {
                print("Error inserting new owner artist into DB.")
                self.reverseCreateArtistIfError(viewModel: viewModel)
                viewModel.alertItem = MyStandardAlertContext.createOwnerArtistFailed
            }
        }
    }
    
    fileprivate func reverseCreateArtistIfError(viewModel: ViewModel) {
        
    }
    
}
