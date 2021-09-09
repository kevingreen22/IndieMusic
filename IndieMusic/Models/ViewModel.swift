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
    
    @Published var showPayWall = false
    
    @Published var searchText: String = ""
    
    
    
    public func setArtworkFor(album: Album) {
        StorageManager.shared.downloadAlbumArtwork(for: album.id) { image in
            guard let img = image else { return }
            self.albumImage = img
        }
    }
    
    
    public func cacheUser() {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        DatabaseManger.shared.getUser(email: email) { user in
            guard let user = user else { return }
            self.user = user
        }
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




