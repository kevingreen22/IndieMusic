//
//  ViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/10/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    struct Constants {
        static let currentlyPlayingMinimizedViewHeight: CGFloat = 53
        static let exploreCellSize: CGFloat = 130
        static let playIndicatorSize: CGFloat = 30
        static let songCellImageSize: CGFloat = 30
    }
    
    @Published var user: User!
    @Published var albumImage: UIImage = UIImage(systemName: "photo")!
    @Published var showSigninView = false
    @Published var alertItem: MyAlertItem?
    @Published var activeSheet: ActiveSheet?
    @Published var showPayWall = false
    @Published var searchText: String = ""
    @Published var selectedSongCell: Song? = nil
    
    
    
//    public func setArtworkFor(album: Album) {
//        StorageManager.shared.downloadAlbumArtwork(for: album.id, artistID: album.artistID) { image in
//            guard let img = image else { return }
//            self.albumImage = img
//        }
//    }
    
    
    public func cacheUser(completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            completion(false)
            return
        }
        DatabaseManger.shared.fetchUser(email: email) { user in
            guard let user = user else { return }
            self.user = user
            completion(true)
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




