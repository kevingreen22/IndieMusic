//
//  ProfileViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/29/21.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @EnvironmentObject var vm: ViewModel
    
    var email: String {
        UserDefaults.standard.string(forKey: "email") ?? ""
    }
    @Published var activeSheet: ActiveSheet?
    @Published var showArtistOwnerInfo = false
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePickerPopover = false
    @Published var showSettings = false
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    
    func uploadUserProfilePicture(email: String, image: UIImage) {
        // save image to storage
        StorageManager.shared.uploadUserProfilePicture(email: email, image: image) { success in
            if success {
                // update database with users photo reference
                DatabaseManger.shared.updateProfilePhotoData(email: email, image: image) { updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        self.vm.cacheUser()
                    }
                    
                    // sets the image cache in the user model
                    self.vm.user.profilePictureData = image.pngData()
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
    
    
    
    
    
    
    func fetchPosts() {
        
    }
    
    
    
    
    
    func removeUsersOwnerPrivelage() {
        // remove artist, albums, songs from DatabaseManager
        // remove uploaded MP3's from StorageManager
        
//        vm.user.isArtistOwner = false
    }
    
    
    
    
    
    
    
    func signOut() {
        AuthManager.shared.signOut { success in
            guard success else { return }
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")            
        }
    }
    
    
    
    
    
    func imagePickerActionSheet() -> ActionSheet {
        ActionSheet(title: Text("Choose Photo from"), message: nil, buttons: [
            .default(Text("Photo Library"), action: {
                self.sourceType = .photoLibrary
                self.showImagePicker.toggle()
            }),
            .default(Text("Camera"), action: {
                self.sourceType = .camera
                self.showImagePicker.toggle()
            }),
            .cancel()
        ])
    }
    
    
    
    
}
