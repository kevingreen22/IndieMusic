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
    
    
    
    func createAlbum(viewModel: ViewModel/*, completion: @escaping (Bool) -> Void*/) {
        // validate
        guard viewModel.user.artist != nil,
              albumName != "",
              genre != "" else {
            viewModel.alertItem = MyStandardAlertContext.infoIncomplete
            return
        }
        
        // set artwork URL
        if selectedImage != nil {
            artworkURL = URL(string: "\(viewModel.user.artist!.name)/\(albumName)/\(SuffixNames.albumArtworkPNG)")
        }
        
        // create a new instance of Album
        let album = Album(title: albumName, artistName: viewModel.user.artist!.name, artistID: viewModel.user.artist!.id, artworkURL: artworkURL, songs: [], year: String(year), genre: genre)
        
        // append new album to user's artist
        viewModel.user.artist!.albums?.append(album)
        
        // save user to database
        DatabaseManger.shared.insert(user: viewModel.user) { success in
            if success {
                print("User model updated")
                
                // save album to database
                DatabaseManger.shared.insert(albums: [album], for: viewModel.user.artist!) { error in
                    if error == nil {
                        print("Owner album inserted into DB.")
                        
                        // Upload album artwork to stroage.
                        guard let image = self.selectedImage else { return }
                        StorageManager.shared.uploadAlbumArtworkImage(album: album, image: image) { success in
                            if success {
                                print("Owner album artwork uploaded.")
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
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    
    
    fileprivate func reverseCreateAlbumIfError(viewModel: ViewModel) {
        
    }
    
    
    

}
