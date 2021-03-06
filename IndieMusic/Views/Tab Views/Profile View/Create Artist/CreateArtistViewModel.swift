//
//  CreateArtistViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/16/21.
//

import SwiftUI

class CreateArtistViewModel: ObservableObject {
    @Published var activeSheet: ActiveSheet?
    @Published var artistName = ""
    @Published var bio = ""
    @Published var genre = "Unknown"
    @Published var newGenreName = ""
    @Published var bioImage: UIImage? = nil
    @Published var url: URL? = nil {
        didSet {
            if let imageURL = url {
                guard let image = UIImage(contentsOfFile: imageURL.path) else { return }
                bioImage = image
            }
        }
    }
    
    
    
    func createArtist(viewModel: MainViewModel) {
        // Validate info
        print("Validating info to create artist...")
        guard let user = viewModel.user else { return }
        guard artistName != "" else {
            print("Validation failed.")
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                viewModel.alertItem = MyErrorContext.infoIncomplete
            }
            return
        }
            
        print("Checking for duplicate artist...")
        DatabaseManger.shared.checkForExistingArtist(name: artistName) { notExists, error in
            guard notExists, error == nil else {
                print("Artist already exists.")
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: error!)
                }
                return
            }
        }
        
        print("Creating new artist object with default album...")
        let ownerArtist = Artist(id: UUID(), name: artistName, genre: genre, imageURL: nil, albums: [])
        
        if bioImage != nil {
            let imageURL = URL(string: "\(FirebaseCollection.artists)/\(ownerArtist.id.uuidString)/\(SuffixNames.bioPicture)")
            ownerArtist.imageURL = imageURL
        }
        
        let defaultAlbum = Album(title: "Untitled", artistName: artistName, artistID: ownerArtist.id.uuidString, artworkURL: nil, songs: [], year: "2021", genre: genre)
        ownerArtist.albums.append(defaultAlbum)
        
        user.artist = ownerArtist
        
        print("Attempting to update User into Firebase DB...")
        DatabaseManger.shared.insert(user: user) { success in
            if success {
                print("User model updated in Firebase DB.")
                
                print("Attempting to insert new artist into Firebase DB...")
                DatabaseManger.shared.insert(artist: user.artist!) { success, error in
                    guard success else { return }
                    
                    guard self.bioImage != nil else { return }
                    print("Attempting to upload artist bio picture...")
                    StorageManager.shared.uploadArtistBioImage(self.bioImage, artist: ownerArtist) { _, error in
                        if error == nil {
                            print("Uploaded artist bio picture successfully.")
                            
                        } else {
                            print("Error uploading artist bio picture.")
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                                viewModel.alertItem = MyErrorContext.getErrorWith(error: error!)
                            }
                        }
                    }
                }
            } else {
                print("Error updating user model with new artist.")
                self.reverseCreateArtistIfError(viewModel: viewModel)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: MyError.error)
                }
            }
        }
    }
    

    
    
    
    fileprivate func reverseCreateArtistIfError(viewModel: MainViewModel) {
        
    }
    
    
}
