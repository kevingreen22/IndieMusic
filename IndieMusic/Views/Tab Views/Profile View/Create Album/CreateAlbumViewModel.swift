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
    @Published var albumName = ""
    @Published var genre: String = "Unknown"
    @Published var newGenreName = ""
    @Published var selectedImage: UIImage?
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var showPickerSheet = false
    @Published var pickImage: Bool? = false
    @Published var url: URL? = nil {
        didSet {
            if let imageURL = url {
                guard let image = UIImage(contentsOfFile: imageURL.path) else { return }
                selectedImage = image
            }
        }
    }
    
    private var artworkURL: URL? = nil
    
    var currentYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        return year
    }
    
    
    func createAlbum(viewModel: ViewModel) {
        // validate
        print("Validating album info...")
        guard let artist = viewModel.user.artist,
              albumName != "" else {
                  print("Validation failied.")
                  DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                      viewModel.alertItem = MyErrorContext.infoIncomplete
                  }
            return
        }
        
        // create a new instance of Album
        print("Creating instance of new album...")
        let album = Album(id: UUID(), title: albumName, artistName: artist.name, artistID: artist.id.uuidString, artworkURL: artworkURL, songs: [], year: String(year), genre: genre)
        
        // Set artwork URL
        print("Creating album artwork URL...")
        if selectedImage != nil {
            artworkURL = URL(string: "\(ContainerNames.artists)/\(album.artistID)/\(album.id)/\(SuffixNames.albumArtworkPNG)")
        }
        
        // Append new album to user's artist
        print("Adding new album to User's artist...")
        artist.albums.append(album)
        
        // Save user to Firestore DB
        print("Attempting to update User...")
        DatabaseManger.shared.insert(user: viewModel.user) { success in
            if success {
                print("User model updated.")
                
                // Upload album artwork to stroage.
                print("Attempting to upload album artowork to Firebase storage...")
                StorageManager.shared.uploadAlbumArtworkImage(album: album, image: self.selectedImage) { success in
                    if success {
                        print("Album artwork uploaded.")
                        
                    } else {
                        print("Error uploading album artwork.")
                        self.reverseCreateAlbumIfError(viewModel: viewModel)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                            viewModel.alertItem = MyErrorContext.generalErrorAlert
                        }
                    }
                }
            } else {
                print("Error updating user model with new owner album.")
                self.reverseCreateAlbumIfError(viewModel: viewModel)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }                
    }
    
    
    
    
    fileprivate func reverseCreateAlbumIfError(viewModel: ViewModel) {
        
    }
    
    
    

}
