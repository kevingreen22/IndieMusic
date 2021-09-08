//
//  UploadSongViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/28/21.
//

import SwiftUI

class UploadSongViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    
    @Published var showAlert = false
    @Published var showImagePicker = false
    
    @Published var artist: Artist? = nil
    @Published var album: Album? = nil
    
    @Published var selectedImage: UIImage? = nil
    
    @Published var songTitle = "Unknown Title"
    @Published var songGenre = "Unknown Genre"
    @Published var lyrics = ""
    
    
    
    
    
    
    func uploadSong() {
        print("Starting song upload...")
        
        guard !songTitle.isEmpty else {
            self.showAlert.toggle()
            print("No Song title")
            return
        }
        
        guard let songURL = URL(string: "create/path/for/song.mp3"),
              let artistID = artist?.id,
              let albumID = album?.id  else {
            print("Problem creating song url path")
            return
        }
        
        // create instance of Song
        let song = Song(title: songTitle, genre: songGenre, artistID: artistID, albumID: albumID, lyrics: lyrics, url: songURL)
          
        
        
//        // upload album artwork image
//        StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image, completion: { success in
//            guard success else { return }
        
//            StorageManager.shared.downloadURLForPostHeader(email: email, postid: newPostid) { artworkURL in
        
        
              
        // insert song into DB
        DatabaseManger.shared.insert(song: song, completion: { posted in
            guard posted else {
                print("Failed to insert new song")
                return
            }
            self.presentationMode.wrappedValue.dismiss()
        })
    }
    
    
}
