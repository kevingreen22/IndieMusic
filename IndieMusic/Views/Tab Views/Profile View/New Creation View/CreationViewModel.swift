//
//  CreationViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/5/21.
//

import SwiftUI

class CreationViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    
    @Published var activeSheet: ActiveSheet?
//    @Published var showAlert = false
    @Published var finishedPickingImage: Bool? = false
    @Published var newGenreName = ""

    
    @Published var artistName = "Unknown Artist"
    @Published var artistGenre = "Unknown"
    @Published var bio = ""
    @Published var bioImage: UIImage? = nil
    
    
    @Published var albumName = "Unknown Album"
    @Published var albumGenre: String = "Unknown"
    @Published var selectedAlbumImage: UIImage?
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var url: URL? = nil {
        didSet {
            if let imageURL = url {
                guard let image = UIImage(contentsOfFile: imageURL.path) else { return }
                selectedAlbumImage = image
            }
        }
    }
    private var artworkURL: URL? = nil
    var currentYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        return year
    }
    
    
    @Published var album: Album = Album()
    @Published var songTitle = "Unknown Title"
    @Published var songGenre = "Unknown"
    @Published var lyrics = ""
    @Published var songLocalFilePath: URL? = nil
    @Published var songFileData: Data? = nil
    @State var songUploadProgress: CGFloat = 0
    
    
    
    
    
    
    func createArtist(viewModel: ViewModel) {
        // Validate info
        print("Validating info to create artist...")
        guard artistName != "" else {
            print("Validation failed.")
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                viewModel.alertItem = MyErrorContext.infoIncomplete
            }
            return
        }
            
        print("Checking for duplicate artist...")
        DatabaseManger.shared.checkForExistingArtist(name: artistName) { notExists, error in
            guard notExists, error != nil else {
                print("Artist already exists.")
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: error!)
                }
                return
            }
        }
             
        print("Creating new artist object with default album...")
        let ownerArtist = Artist(name: artistName, genre: artistGenre, imageURL: nil, albums: [])
        let defaultAlbum = Album(title: "Untitled", artistName: artistName, artistID: ownerArtist.id.uuidString, artworkURL: nil, songs: [], year: "2021", genre: albumGenre)
        ownerArtist.albums.append(defaultAlbum)
        viewModel.user.artist = ownerArtist
        
        print("Attempting to update User into Firebase DB...")
        DatabaseManger.shared.insert(user: viewModel.user) { success in
            if success {
                print("User model updated in Firebase DB.")
                
                print("Attempting to insert new artist into Firebase DB...")
                DatabaseManger.shared.insert(artist: viewModel.user.artist!) { success in
                    guard success else { return }
                    
                    print("Attempting to upload artist bio picture if it exists...")
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
                self.reverseCreationIfError(viewModel: viewModel)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: MyError.error)
                }
            }
        }
    }
    

    
    func createAlbum(viewModel: ViewModel) {
        // validate
        print("Validating album info...")
        guard viewModel.user.artist != nil,
              albumName != "" else {
                  print("Validation failied.")
                  DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                      viewModel.alertItem = MyErrorContext.infoIncomplete
                  }
            return
        }
        
        // Set artwork URL
        print("Creating album artwork URL...")
        if selectedAlbumImage != nil {
            artworkURL = URL(string: "\(viewModel.user.artist!.name)/\(albumName)/\(SuffixNames.albumArtworkPNG)")
        }
        
        // create a new instance of Album
        print("Creating instance of new album...")
        let album = Album(title: albumName, artistName: viewModel.user.artist!.name, artistID: viewModel.user.artist!.id.uuidString, artworkURL: artworkURL, songs: [], year: String(year), genre: albumGenre)
        
        // Append new album to user's artist
        print("Adding new album to User...")
        viewModel.user.artist!.albums.append(album)
        
        // Save user to Firestore DB
        print("Attempting to update User...")
        DatabaseManger.shared.insert(user: viewModel.user) { success in
            if success {
                print("User model updated.")
                
                // Upload album artwork to stroage.
                print("Attempting to upload album artowork to Firebase storage...")
                StorageManager.shared.uploadAlbumArtworkImage(album: album, image: self.selectedAlbumImage) { success in
                    if success {
                        print("Album artwork uploaded.")
                        
                    } else {
                        print("Error uploading album artwork.")
                        self.reverseCreationIfError(viewModel: viewModel)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                            viewModel.alertItem = MyErrorContext.generalErrorAlert
                        }
                    }
                }
            } else {
                print("Error updating user model with new owner album.")
                self.reverseCreationIfError(viewModel: viewModel)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }
    }
    
    
    
    func uploadSong(viewModel: ViewModel) {
        // Validate info
        withAnimation {
            viewModel.showNotification.toggle()
            viewModel.notificationText = "Verifying..."
        }
        print("Verifying song info...")
        guard viewModel.user.artist != nil,
              !songTitle.isEmpty else {
                  print("Required Song info not complete.")
                  withAnimation { viewModel.showNotification.toggle() }
                  DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                      viewModel.alertItem = MyErrorContext.infoIncomplete
                  }
                  return
              }
        
        // Generate URL for song path in Firebase Storage container
        print("Generating URL For song path in Firebase...")
        withAnimation { viewModel.notificationText = "GeneratingURL..." }
        guard let songURL = URL(string: "\(ContainerNames.artists)/\(album.id)/\(songTitle)\(SuffixNames.mp3)") else {
            print("Problem creating song url path/id's")
            withAnimation { viewModel.showNotification.toggle() }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                viewModel.alertItem = MyErrorContext.generalErrorAlert
            }
            return
        }
        
        // Create new instance of Song object
        print("Creating new instance of song...")
        viewModel.notificationText = "Creating..."
        let song = Song(title: songTitle, albumTitle: album.title, artistName: viewModel.user.artist!.name, genre: songGenre, artistID: viewModel.user.artist!.id.uuidString, albumID: album.id.uuidString, lyrics: lyrics, url: songURL)
        
        
        // Upload song to storage
        print("Attempting to upload song to storage...")
        viewModel.notificationText = "Uploading..."
        StorageManager.shared.upload(song: song, fileData: songFileData,  localFilePath: songLocalFilePath) { snapshot in
            switch snapshot.status {
            case .progress:
                viewModel.uploadProgress = 100 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                                
            case .success:
                print("Song .mp3 uploaded.")
                
                // Add the song to the albums array of songs
                print("Adding new song to user albums...")
                viewModel.notificationText = "Adding to album..."
                guard let album = viewModel.user.artist!.albums.first(where: { $0.id.uuidString == song.albumID }) else {
                    print("Error getting album for song.")
                    self.reverseCreationIfError(viewModel: viewModel)
                    withAnimation { viewModel.showNotification.toggle() }
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                        viewModel.alertItem = MyErrorContext.generalErrorAlert
                    }
                    return
                }
                album.songs.append(song)
                
                self.updateArtist(viewModel: viewModel, song: song, album: album, image: self.bioImage)
                
            case .failure, .unknown:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.reverseCreationIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: error)
                }
                
            case .pause, .resume:
                print("song upload paused/resumed")
                    
            @unknown default:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.reverseCreationIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: error)
                }
            }
        }
    }
    
    
    // Update Artist in Firestore DB
    fileprivate func updateArtist(viewModel: ViewModel, song: Song, album: Album, image: UIImage?) {
        print("Attempting to update artist in DB...")
        viewModel.notificationText = "Updating artist..."
        DatabaseManger.shared.insert(artist: viewModel.user.artist!) { success in
            if success {
                print("Artist object updated in DB.")
                self.uploadAlbumArtwork(image: image, album: album, viewModel: viewModel)
            } else {
                print("Failed to update artist with new song in DB.")
                self.reverseCreationIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }
    }
    
    
    // Upload album artwork to storage
    fileprivate func uploadAlbumArtwork(image: UIImage?, album: Album, viewModel: ViewModel) {
        guard image != nil else {
            self.updateUser(user: viewModel.user, viewModel: viewModel)
            return
        }
        
        print("Attempting to upload album artwork to storage...")
        viewModel.notificationText = "Uploading artwork..."
        StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image) { success in
            if success {
                print("Album artwork uploaded successfully.")
                self.updateUser(user: viewModel.user, viewModel: viewModel)
            } else {
                print("Error uploading album artwork.")
                self.reverseCreationIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }
    }
    
    
    // Update user in Firestore DB
    fileprivate func updateUser(user: User, viewModel: ViewModel) {
        print("Attempting to update User to the DB...")
        viewModel.notificationText = "Updating user..."
        DatabaseManger.shared.insert(user: user) { success in
            if success {
                print("User model updated.")
                
            } else {
                print("Error updating user model with new song.")
                self.reverseCreationIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }
        
        withAnimation { viewModel.showNotification.toggle() }
    }
    
    
    
    
    
    
    
    fileprivate func reverseCreationIfError(viewModel: ViewModel) {
        
    }
    
    
    
    
}
