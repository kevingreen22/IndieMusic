//
//  ProfileViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/29/21.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    var email: String {
        UserDefaults.standard.string(forKey: "email") ?? ""
    }
    @Published var alertItem: MyAlertItem?
    @Published var showArtistOwnerInfo: Bool = false
    @Published var showSettings = false
    @Published var showLoader = false
    @Published var selectedImage: UIImage? = nil
    @Published var url: URL? = nil {
        didSet {
            if let imageURL = url {
                guard let image = UIImage(contentsOfFile: imageURL.path) else { return }
                selectedImage = image
            }
        }
    }
    
    
    // Updates user profile picture in Firebase storage, then updates the User in Firebase DB.
    func updateUsersProfilePicture(user: User) {
        guard let image = selectedImage else { return }
        let profilePictureURL = URL(string: "\(ContainerNames.profilePictures)/\(user.email.underscoredDotAt())/\(SuffixNames.photoPNG)")
        user.profilePictureURL = profilePictureURL
        
        // save image to storage
        StorageManager.shared.uploadUserProfilePicture(user: user, image: image) { success in
            if success {
                
                // update user in DB
                DatabaseManger.shared.update(user: user) { success, error in
                    
                }
            }
        }
    }
    
    
    func fetchUserProfilePicture(_ user: User) {
        StorageManager.shared.downloadProfilePictureFor(user: user) { uiimage in
            guard let uiimage = uiimage else { return }
            DispatchQueue.main.async {
                self.selectedImage = uiimage
            }
        }
    }
    
    
    func getAlbumArtworkFor(song: Song) -> UIImage {
        var _image = UIImage.albumArtworkPlaceholder
        StorageManager.shared.downloadAlbumArtworkFor(albumID: song.albumID, artistID: song.artistID) { image in
            guard let image = image else { return }
            _image = image
        }
        return _image
    }
    
    
    func removeUsersOwnerPrivilage(viewModel: MainViewModel) {
        print("Attempting to removing User Artist owner privilage...")
        var errors: [Error]? = nil
        let group = DispatchGroup()
        
        group.enter()
        // remove uploaded MP3's from Firebase Storage
        for album in viewModel.user.artist!.albums {
            for song in album.songs {
                StorageManager.shared.delete(song: song) { error in
                    if let error = error {
                        errors?.append(error)
                    }
                    print("Deleted song from storage")
                    group.wait()
                }
            }
            
            group.enter()
            // remove uploaded album artworks from Firebase Storage
            StorageManager.shared.deleteAlbumArtwork(album) { error in
                if let error = error {
                    errors?.append(error)
                }
                print("Deleted album artwork from stroage")
                group.wait()
            }
        }
        
        group.enter()
        // remove artist from Firebase DB
        DatabaseManger.shared.delete(artist: viewModel.user.artist!) { _, error in
            if let error = error {
                errors?.append(error)
            }
            print("Deleted artist from DB")
            group.leave()
        }
        
        let result1 = group.wait(timeout: .now() + 30)
        switch result1 {
        case .success:
            viewModel.user.artist = nil
            print("Artist deleted from User Model")
        case .timedOut:
            // try again
            print("dispatch group timed out. trying again.")
            removeUsersOwnerPrivilage(viewModel: viewModel)
        }
        
        group.enter()
        // save user to Firebase DB
        DatabaseManger.shared.update(user: viewModel.user) { _, error in
            if let error = error {
                errors?.append(error)
            }
            print("User updated in DB")
            group.wait()
        }


        group.enter()
        // then re-cache user
        viewModel.cacheUser { success in
            guard success else { return }
            print("User re-cached after removing owner artist")
            group.leave()
        }

        let result2 = group.wait(timeout: .now() + 10)
        switch result2 {
        case .success:
            print("removal of User's Owner Privelage and artist completed.")
        case .timedOut:
            // try again
            print("dispatch group timed out.")
            alertItem = MyErrorContext.myAlertWith(title: "Process timed out", message: nil, action: { self.removeUsersOwnerPrivilage(viewModel: viewModel) }
            )
        }

    }
    
    
    func signOut(viewModel: MainViewModel, completion: @escaping (Bool) -> Void) {
        AuthManager.shared.signOut { success in
            guard success else { completion(false); return }
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")
            completion(true)
        }
    }
    
    
    
    
    
}
