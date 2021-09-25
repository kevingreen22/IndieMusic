//
//  CreateArtistViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateArtistViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var artistName = ""
    @Published var bio = ""
    @Published var genre = "Unknown"
    @Published var newGenreName = ""
    @Published var bioImage: UIImage? = nil
    @Published var showImagePicker = false
    
    
    
    func createArtist(viewModel: ViewModel) {
        // Validate info
        guard artistName != "" else {
            print("Required artist info not completed.")
//            viewModel.alertItem = MyStandardAlertContext.infoIncomplete
            return
        }
                
//        DatabaseManger.shared.checkForExistingArtist(name: artistName) { exists in
//            guard exists else {
//                print("Artist already exists.")
////                viewModel.alertItem = MyStandardAlertContext.artistAlreadyExists
//                return
//            }
//        }
             
        let ownerArtist = Artist(name: artistName, genre: genre, imageURL: nil, albums: [])
        let defaultAlbum = Album(title: "Untitled", artistName: artistName, artistID: ownerArtist.id, artworkURL: nil, songs: [], year: "2021", genre: genre)
        ownerArtist.albums.append(defaultAlbum)
        
        DatabaseManger.shared.insert(artist: ownerArtist) { success in
            if success {
                print("New artist inserted into DB.")
                
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
        
//        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    fileprivate func reverseCreateArtistIfError(viewModel: ViewModel) {
        
    }
    
    
}
