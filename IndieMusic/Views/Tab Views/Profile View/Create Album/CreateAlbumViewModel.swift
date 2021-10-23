//
//  CreateAlbumViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateAlbumViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var activeSheet: ActiveSheet?
    @Published var selectedImage: UIImage?
    @Published var artworkImageData: Data? = nil {
        didSet {
            if let imageData = artworkImageData {
                guard let image = UIImage(data: imageData) else { return }
                selectedImage = image
            }
        }
    }
    @Published var newGenreName = ""
    @Published var albumName = ""
    @Published var genre: String = "Unknown"
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    
    var currentYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        return year
    }
    
    
    func createAlbum(viewModel: MainViewModel) {
        // validate
        print("Validating album info...")
        guard let user = viewModel.user, let artist = user.artist,
              albumName != "" else {
                  print("Validation failied.")
                  DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                      viewModel.alertItem = MyErrorContext.infoIncomplete
                  }
            return
        }
        
        // create a new instance of Album
        print("Creating instance of new album...")
        let id = UUID()
        var artworkURL: URL? = nil
        if selectedImage != nil {
            artworkURL = URL(string: "\(FirebaseCollection.artists)/\(artist.id.uuidString)/\(id)/\(SuffixNames.albumArtworkPNG)")
        }
        let album = Album(id: id, title: albumName, artistName: artist.name, artistID: artist.id.uuidString, artworkURL: artworkURL, songs: [], year: String(year), genre: genre)
        
        // Append new album to user's artist
        print("Adding new album to User's artist...")
        artist.albums.append(album)
        
        // Save user to Firestore DB
        print("Attempting to update User...")
        DatabaseManger.shared.insert(user: user) { [weak self] success in
            if success {
                print("User model updated.")
                
                // Upload album artwork to stroage.
                print("Attempting to upload album artowork to Firebase storage...")
                StorageManager.shared.uploadAlbumArtworkImage(album: album, image: self?.selectedImage) { [weak self] success in
                    if success {
                        print("Album artwork uploaded.")
                        
                    } else {
                        print("Error uploading album artwork.")
                        self?.reverseCreateAlbumIfError(viewModel: viewModel)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                            viewModel.alertItem = MyErrorContext.generalErrorAlert
                        }
                    }
                }
            } else {
                print("Error updating user model with new owner album.")
                self?.reverseCreateAlbumIfError(viewModel: viewModel)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }                
    }
    
    
    
    
    fileprivate func reverseCreateAlbumIfError(viewModel: MainViewModel) {
        
    }
    
    
    

}
