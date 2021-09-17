//
//  CreateAlbumViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateAlbumViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var albumName = ""
    @Published var genre: String?
    @Published var selectedImage: UIImage?
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var showImagePicker = false
    @Published var pickImage: Bool? = false
    
    
    var currentYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        return year
    }
    
    
    func createAlbum(viewModel: ViewModel) {
        guard let ownerArtist = viewModel.user.artist,
              albumName != "",
              let genre = genre else {
            viewModel.alertItem = MyStandardAlertContext.infoIncomplete
            return
        }
        
        let artworkURL = URL(string: "\(ownerArtist.name)/\(albumName)/\(SuffixNames.albumArtworkPNG)")
        
        let album = Album(title: albumName, artistName: ownerArtist.name, artistID: ownerArtist.id, artworkURL: artworkURL, songs: [], year: String(year), genre: genre)
        
        // append new album to user's artist
        ownerArtist.albums?.append(album)
        
        // save owner album to database
        DatabaseManger.shared.insert(album: album) { success in
            if success {
                print("Owner album inserted into DB.")
                
                // save user to database
                DatabaseManger.shared.insert(user: viewModel.user) { success in
                    if success {
                        print("User model updated")
                        
                        // Upload album artwork to stroage.
                        guard let image = self.selectedImage else { return }
                        StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image) { success in
                            if success {
                                print("Owner album artwork uploaded.")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error uploading album artwork.")
                                self.reverseCreateAlbumIfError(viewModel: viewModel)
                                viewModel.alertItem = MyStandardAlertContext.createAlbumFailed
                            }
                        }
                    } else {
                        print("Error updating user model with new owner album.")
                        self.reverseCreateAlbumIfError(viewModel: viewModel)
                        viewModel.alertItem = MyStandardAlertContext.createAlbumFailed
                    }
                }
            } else {
                print("Error inserting owner album into DB.")
                self.reverseCreateAlbumIfError(viewModel: viewModel)
                viewModel.alertItem = MyStandardAlertContext.createAlbumFailed
            }
        }
    }
    
    
    fileprivate func reverseCreateAlbumIfError(viewModel: ViewModel) {
        
    }
    
    
    

}
