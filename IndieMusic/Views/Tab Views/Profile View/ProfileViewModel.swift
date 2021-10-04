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
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePickerPopover = false
    @Published var showSettings = false
    
    
    
    func uploadUserProfilePicture(viewModel: ViewModel, email: String, image: UIImage) {
        // save image to storage
        StorageManager.shared.uploadUserProfilePicture(email: email, image: image) { success in
            if success {
                // update database with users photo reference
                DatabaseManger.shared.updateProfilePhotoData(email: email, image: image) { updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        viewModel.cacheUser(completion: { _ in })
                    }
                    
                    // sets the image cache in the user model
                    viewModel.user.profilePictureData = image.pngData()
                }
            }
        }
    }
    
    
    func fetchUserProfilePicture(_ user: User) {
        if let pngData = user.profilePictureData {
            self.selectedImage = UIImage(data: pngData)
        } else {
            let path = "\(ContainerNames.profilePictures)/\(user.email.underscoredDotAt())/\(SuffixNames.photoPNG)"
            StorageManager.shared.downloadURLForProfilePicture(path: path) { url in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let _data = data else { return }
                    print("profile picture downloaded from storage")
                    DispatchQueue.main.async {
                        self.selectedImage = UIImage(data: _data)
                    }
                }
                task.resume()
            }
        }
    }
    
    
    func getAlbumArtworkFor(song: Song) -> UIImage {
        var _image = UIImage(named: "album_artwork_placeholder")!
        StorageManager.shared.downloadAlbumArtworkFor(albumID: song.albumID, artistID: song.artistID) { image in
            guard let image = image else { return }
            _image = image
        }
        return _image
    }
    
    
    func removeUsersOwnerPrivilage(viewModel: ViewModel) {
        print("Removing User Artist owner privilage...")
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
                    group.leave()
                }
            }
            
            group.enter()
            // remove uploaded album artworks from Firebase Storage
            StorageManager.shared.deleteAlbumArtwork(album) { error in
                if let error = error {
                    errors?.append(error)
                }
                group.leave()
            }
        }
        
        group.enter()
        // remove artist from Firebase DB
        DatabaseManger.shared.delete(artist: viewModel.user.artist!) { _, error in
            if let error = error {
                errors?.append(error)
            }
            group.leave()
        }
        
        let result1 = group.wait(timeout: DispatchTime.now())
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
            group.leave()
        }
        
        
        group.enter()
        // then re-cache user
        viewModel.cacheUser { success in
            guard success else { return }
            print("User re-cached after removing owner artist")
            group.leave()
        }
        
        let result2 = group.wait(timeout: DispatchTime.now())
        switch result2 {
        case .success:
            print("remove Users Owner Privelage and artist completed.")
        case .timedOut:
            // try again
            print("dispatch group timed out.")
            alertItem = MyErrorContext.myAlertWith(title: "Process timed out", message: nil, action: { self.removeUsersOwnerPrivilage(viewModel: viewModel) }
            )
            
        }

    }
    
    
    func signOut() {
        AuthManager.shared.signOut { success in
            guard success else { return }
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")            
        }
    }
    
    
    func imagePickerActionSheet(viewModel: ViewModel) -> ActionSheet {
        ActionSheet(title: Text("Choose Photo from"), message: nil, buttons: [
            .default(Text("Photo Library"), action: {
                viewModel.activeSheet = .imagePicker(sourceType: .photoLibrary)
            }),
            .default(Text("Camera"), action: {
                viewModel.activeSheet = .imagePicker(sourceType: .camera)
            }),
            .cancel()
        ])
    }
    
    
    
    
    
    
    
}
