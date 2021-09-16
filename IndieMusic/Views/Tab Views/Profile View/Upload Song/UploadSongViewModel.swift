//
//  UploadSongViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/28/21.
//

import SwiftUI

class UploadSongViewModel: ObservableObject {
    @EnvironmentObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Published var showImagePicker = false
    
    @Published var artist: Artist? = nil
    @Published var album: Album? = nil
    
    @Published var selectedImage: UIImage? = nil
    
    @Published var songTitle = ""
    @Published var songGenre = ""
    @Published var lyrics = ""
    
    @Published var uploadProgress: Double = 0
    
    
    
    
    func uploadSong() {
        print("Starting song upload...")
        
        // Validate info
        guard !songTitle.isEmpty,
              let album = self.album,
              let artist = self.artist else {
            print("No Song title.")
            vm.alertItem = MySongUploadAlertsContext.noSongTitle
            return
        }
        
        // Generate URL for song path
        guard let songURL = URL(string: "\(ContainerNames.artists)/\(ContainerNames.albums)/\(ContainerNames.songs)/\(songTitle)/\(SuffixNames.mp3)") else {
            print("Problem creating song url path/id's")
            vm.alertItem = MySongUploadAlertsContext.creatingURLError
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
                self.insertSongToDB(song: song, album: album, image: self.selectedImage)
                
            case .failure:
                guard let error = snapshot.error else { return }
                print("There was and error uploading song: \(error.localizedDescription)")
                self.vm.alertItem = MySongUploadAlertsContext.uploadSongError(error)
                
            case .pause, .resume, .unknown:
                break
            @unknown default:
                fatalError()
            }
        }
        
        
    }
    
    
    fileprivate func insertSongToDB(song: Song, album: Album, image: UIImage?) {
        print("Attempting to insert song into DB...")
        
        // Insert song into DB
        DatabaseManger.shared.insert(song: song, completion: { posted in
            if !posted {
                print("Failed to insert new song into DB.")
                self.vm.alertItem = MySongUploadAlertsContext.insertSongToDBError
                return
            } else {
                print("Song object inserted into DB.")
                self.uploadAlbumArtwork(image: image, album: album)
            }
        })
    }
    
    
    fileprivate func uploadAlbumArtwork(image: UIImage?, album: Album) {
        // Upload album artwork image
        if let imageArtwork = image {
            print("Attempting to upload album artwork into DB...")
            StorageManager.shared.uploadAlbumArtworkImage(album: album, image: imageArtwork, completion: { success in
                if !success {
                    print("Failed to upload album artwork.")
                    return
                }
                print("Album artwork uploaded into DB.")
            })
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
}
