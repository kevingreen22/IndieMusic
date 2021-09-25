//
//  UploadSongViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/28/21.
//

import SwiftUI

class UploadSongViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var showDocumentPicker = false
    @Published var showAlert = false
    @Published var artist: Artist? = nil
    @Published var album: Album? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var songTitle = ""
    @Published var songGenre = "Unknown"
    @Published var newGenreName = ""
    @Published var lyrics = ""
    @Published var uploadProgress: Double = 0
    @Published var localFilePath: URL? = nil
    
    
    
    
    func uploadSong(viewModel: ViewModel) {
        print("Verifying song info...")
        
        // Validate info
        guard !songTitle.isEmpty,
              let album = self.album,
              let artist = self.artist else {
                  print("Required Song info not complete.")
//                  viewModel.alertItem = MySongUploadAlertsContext.songInfoIncomplete
                  return
              }
        
        // Generate URL for song path in Firebase Storage container
        guard let songURL = URL(string: "\(ContainerNames.artists)/\(album.id)/\(songTitle)/\(SuffixNames.mp3)") else {
            print("Problem creating song url path/id's")
            viewModel.alertItem = MySongUploadAlertsContext.creatingURLError
            return
        }
        
        // Create new instance of Song object
        let song = Song(title: songTitle, genre: songGenre, artistID: artist.id, albumID: album.id, lyrics: lyrics, url: songURL)
        
        // verify the user has an artist ownership
        guard viewModel.user.artist != nil else { return }
        
        // add the song to the albums array of songs
        if let album = viewModel.user.artist!.albums.first(where: { $0.id == song.albumID }) {
            album.songs.append(song)
        }
        
        // Upload song to storage
        print("Attempting to upload song to storage...")
        StorageManager.shared.upload(song: song, localFilePath: localFilePath) { snapshot in
            print(snapshot.status)
            switch snapshot.status {
            case .progress:
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                self.uploadProgress = percentComplete
                
            case .success:
                print("Song .mp3 uploaded.")
                self.updateArtist(viewModel: viewModel, song: song, album: album, image: self.selectedImage)
                
            case .failure:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.reverseUploadSongIfError(viewModel: viewModel)
                viewModel.alertItem = MySongUploadAlertsContext.uploadSongError(error)
                
            case .pause, .resume, .unknown:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    
    // Update Artist in Firestore DB
    fileprivate func updateArtist(viewModel: ViewModel, song: Song, album: Album, image: UIImage?) {
        print("Attempting to update artist in DB...")

        DatabaseManger.shared.insert(artist: viewModel.user.artist!) { success in
            if success {
                print("Artist object updated in DB.")
                self.uploadAlbumArtwork(image: image, album: album, viewModel: viewModel)
            } else {
                print("Failed to update artist with new song in DB.")
                self.reverseUploadSongIfError(viewModel: viewModel)
                viewModel.alertItem = MySongUploadAlertsContext.insertSongToDBError
            }
        }
    }
    
    
    // Upload album artwork to storage
    fileprivate func uploadAlbumArtwork(image: UIImage?, album: Album, viewModel: ViewModel) {
        print("Attempting to upload album artwork to storage...")
        
        StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image) { success in
            if success {
                print("Album artwork uploaded successfully.")
                self.updateUser(user: viewModel.user, viewModel: viewModel)
            } else {
                print("Error uploading album artwork.")
                self.reverseUploadSongIfError(viewModel: viewModel)
                viewModel.alertItem = MyStandardAlertContext.generalErrorAlert
            }
        }
    }
    
    
    // Update user in Firestore DB
    fileprivate func updateUser(user: User, viewModel: ViewModel) {
        print("Attempting to update/insert User to the DB...")
        
        DatabaseManger.shared.insert(user: user) { success in
            if success {
                print("User model updated.")
                self.presentationMode.wrappedValue.dismiss()
            } else {
                print("Error updating user model with new song.")
                self.reverseUploadSongIfError(viewModel: viewModel)
                viewModel.alertItem = MyStandardAlertContext.generalErrorAlert
            }
        }
    }
    
    
    
    fileprivate func reverseUploadSongIfError(viewModel: ViewModel) {
        
    }
    
    
    
    
   
    
}
