//
//  ViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/10/21.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    struct Constants {
        static let currentlyPlayingMinimizedViewHeight: CGFloat = 60
        static let playIndicatorSize: CGFloat = 30
        static let songCellImageSize: CGFloat = 30
    }
    
    @Published var user: User!
    @Published var showSplash = true
    @Published var initProgress: CGFloat = 0.0
    @Published var initProgressText = "fetching..."
    @Published var showSigninView = false
    @Published var alertItem: MyAlertItem?
    @Published var activeSheet: ActiveSheet?
    @Published var activeFullScreen: ActiveFullScreen?
    @Published var selectedTab: Int = 2
    @Published var searchText: String = ""
    @Published var selectedSongCell: Song? = nil
    @Published var uploadProgress: CGFloat = 0
    @Published var showNotification = false
    @Published var notificationText = "Uploading..."

    
    
    
    func fetchBioImageFor(artist: Artist) -> UIImage {
        var bioImage = UIImage.bioPlaceholder
        StorageManager.shared.downloadArtistBioImage(artist: artist) { image in
            guard let image = image else { return }
            bioImage = image
        }
        return bioImage
    }
    
    func fetchAlbumArtworkFor(album: Album) -> UIImage {
        var artwork = UIImage.albumArtworkPlaceholder
        StorageManager.shared.downloadAlbumArtworkFor(album: album){ image in
            guard let image = image else { return }
            artwork = image
        }
        return artwork
    }
    
    func fetchAlbumArtworkFor(song: Song) -> UIImage {
        var artwork = UIImage.albumArtworkPlaceholder
        StorageManager.shared.downloadAlbumArtworkFor(albumID: song.albumID, artistID: song.artistID) { image in
            guard let image = image else { return }
            artwork = image
        }
        return artwork
    }
    
    
    public func cacheUser(completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            completion(false)
            return
        }
        DispatchQueue.global().async {
            DatabaseManger.shared.fetchUser(email: email) { user in
                guard let user = user else { return }
                self.user = user
                StorageManager.shared.downloadProfilePictureFor(user: user) { uiimage in
                    guard let image = uiimage else { return }
                    guard let data = image.jpegData(compressionQuality: 1) else { return}
                    user.profilePictureData = data
                }
                completion(true)
            }
        }
    }
    
    
    public func cacheGenres(completion: (([String]?, Error?) -> Void)? = nil) {
        DatabaseManger.shared.fetchGenres { genres, error in
            guard let genres = genres, error == nil else { completion?(nil, error); return }
            Genres.names = genres
            completion?(genres, nil)
        }
    }
    
    public func saveNewGenre(newGenreName: String) {
        DatabaseManger.shared.addNewGenre(newGenreName, completion: { success in
            self.cacheGenres()
        })
    }
    
    
    
    /// Decides if the app is being opened from iPhone Home screen and not the background.
    /// This UserDefault gets set in main .app file when the sceenPhase goes to inactive.
    var isOpeningApp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "openingApp")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "openingApp")
        }
    }
    
    
}




