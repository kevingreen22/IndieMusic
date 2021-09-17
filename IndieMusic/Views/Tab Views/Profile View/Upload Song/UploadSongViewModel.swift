//
//  UploadSongViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/28/21.
//

import SwiftUI

class UploadSongViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    @Published var showImagePicker = false
    @Published var artist: Artist? = nil
    @Published var album: Album? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var songTitle = ""
    @Published var songGenre = ""
    @Published var lyrics = ""
    @Published var uploadProgress: Double = 0
    
    
    
    
    func uploadSong(viewModel: ViewModel) {
        print("Starting song upload...")
        
        // Validate info
        guard !songTitle.isEmpty,
              let album = self.album,
              let artist = self.artist else {
            print("Required Song info not complete.")
            viewModel.alertItem = MySongUploadAlertsContext.songInfoIncomplete
            return
        }
        
        // Generate URL for song path
        guard let songURL = URL(string: "\(ContainerNames.artists)/\(ContainerNames.albums)/\(ContainerNames.songs)/\(songTitle)/\(SuffixNames.mp3)") else {
            print("Problem creating song url path/id's")
            viewModel.alertItem = MySongUploadAlertsContext.creatingURLError
            return
        }
        
        // Create new instance of Song object
        let song = Song(title: songTitle, genre: songGenre, artistID: artist.id, albumID: album.id, lyrics: lyrics, url: songURL)
          
        
        // Upload song to storage container
        StorageManager.shared.upload(song: song, localFilePath: songURL) { snapshot in
            print(snapshot.status)
            switch snapshot.status {
            case .progress:
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                self.uploadProgress = percentComplete
                
            case .success:
                print("Song MP3 uploaded.")
                self.insertSongToDB(viewModel: viewModel, song: song, album: album, image: self.selectedImage)
                
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
    
    
    fileprivate func insertSongToDB(viewModel: ViewModel, song: Song, album: Album, image: UIImage?) {
        print("Attempting to insert song into DB...")
        
        // Insert song into DB
        DatabaseManger.shared.insert(song: song, completion: { success in
            if success {
                print("Song object inserted into DB.")
                self.updateUser(viewModel: viewModel, with: song, for: album)
            } else {
                print("Failed to insert new song into DB.")
                self.reverseUploadSongIfError(viewModel: viewModel)
                viewModel.alertItem = MySongUploadAlertsContext.insertSongToDBError
            }
        })
    }
    
    
    fileprivate func updateUser(viewModel: ViewModel, with song: Song, for album: Album) {
        guard let artist = viewModel.user.artist else { return }
        guard let album = artist.albums?.first(where: { $0 == album }) else { return }
        album.songs.append(song)
        
        DatabaseManger.shared.insert(user: viewModel.user) { success in
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
