//
//  UploadSongViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/28/21.
//

import SwiftUI

class UploadSongViewModel: ObservableObject {
    @Published var showDocumentPicker = false
    @Published var showAlert = false
    @Published var artist: Artist? = nil
    @Published var album: Album = Album()
    @Published var selectedImage: UIImage? = nil
    @Published var songTitle = ""
    @Published var songGenre = "Unknown"
    @Published var newGenreName = ""
    @Published var lyrics = ""
    @Published var localFilePath: URL? = nil
    @Published var fileData: Data? = nil
    
    @State var uploadProgress: CGFloat = 0
    
    
    
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
        StorageManager.shared.upload(song: song, fileData: fileData,  localFilePath: localFilePath) { snapshot in
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
                    self.reverseUploadSongIfError(viewModel: viewModel)
                    withAnimation { viewModel.showNotification.toggle() }
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                        viewModel.alertItem = MyErrorContext.generalErrorAlert
                    }
                    return
                }
                album.songs.append(song)
                
                self.updateArtist(viewModel: viewModel, song: song, album: album, image: self.selectedImage)
                
            case .failure, .unknown:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.reverseUploadSongIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.getErrorWith(error: error)
                }
                
            case .pause, .resume:
                print("song upload paused/resumed")
                    
            @unknown default:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.reverseUploadSongIfError(viewModel: viewModel)
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
                self.reverseUploadSongIfError(viewModel: viewModel)
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
                self.reverseUploadSongIfError(viewModel: viewModel)
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
                self.reverseUploadSongIfError(viewModel: viewModel)
                withAnimation { viewModel.showNotification.toggle() }
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    viewModel.alertItem = MyErrorContext.generalErrorAlert
                }
            }
        }
        
        withAnimation { viewModel.showNotification.toggle() }
    }
    
    
    
    fileprivate func reverseUploadSongIfError(viewModel: ViewModel) {
        
    }
    
    
    
    
   
    
}
