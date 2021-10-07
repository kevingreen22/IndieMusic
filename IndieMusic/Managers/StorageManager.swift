//
//  StorageManager.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    
    
    
    
    
    
    // MARK: song storage methods
    
    public func upload(song: Song, fileData: Data?, localFilePath: URL?, completion: @escaping (StorageTaskSnapshot) -> Void) {
        // File located on disk
//        guard let localFilePath = localFilePath else { return }
        guard let file = fileData else { return }
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"

        let ref = container.reference().child("\(ContainerNames.artists)/\(song.artistID)/\(song.albumID)/\(song.title)\(SuffixNames.mp3)")
        
//        let task = ref.putFile(from: localFilePath, metadata: metadata)
        let task = ref.putData(file, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        task.observe(.resume) { snapshot in
          // Upload resumed, also fires when the upload starts
            print("Song upload started/resumed...")
            completion(snapshot)
        }

        task.observe(.pause) { snapshot in
          // Upload paused
            print("Song upload paused...")
            completion(snapshot)
        }
        
        task.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Song upload progress: \(percentComplete)%")
            completion(snapshot)
        }
        
        task.observe(.success) { snapshot in
            // Upload completed successfully
            print("Song upload successfully.")
            completion(snapshot)
        }
        
        task.observe(.failure) { snapshot in
            task.cancel()
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    completion(snapshot)

                case .unauthorized:
                    // User doesn't have permission to access file
                    completion(snapshot)

                case .cancelled:
                    // User canceled the upload
                    completion(snapshot)
                
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    completion(snapshot)

                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    completion(snapshot)

                }
            }
        }
        
    }
    
    
    public func delete(song: Song, completion: @escaping (Error?) -> Void) {
        let path = "\(ContainerNames.artists)/\(song.artistID)/\(song.albumID)/\(song.id)\(SuffixNames.mp3)"
        container
            .reference(withPath: path)
            .delete { error in
                if error != nil {
                    print("Error deleting song from Firebase Storage: \(error!))")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
    
    
    
    
    
    
    // MARK: Album artwork storage methods
    
    public func uploadAlbumArtworkImage(album: Album, image: UIImage?, completion: @escaping (Bool) -> Void) {
        //        let path = "\(ContainerNames.artists)/\(album.artistID)/\(album.id)/\(SuffixNames.albumArtworkPNG)"
        
        guard let path = album.artworkURL?.absoluteString else { return }
        guard let pngData = image?.pngData() else { return }

        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false); return }
                completion(true)
            }
    }
    
    
    public func downloadAlbumArtworkFor(albumID: String, artistID: String, completion: @escaping (UIImage?) -> Void) {
        let path = "\(ContainerNames.artists)/\(artistID)/\(albumID)/\(SuffixNames.albumArtworkPNG)"
        self.container
            .reference(withPath: path)
            .downloadURL { url, _ in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let _data = data else { return }
                    guard let uiimage = UIImage(data: _data) else { return }
                    completion(uiimage)
                }
                task.resume()
            }
    }
    
    
    public func downloadAlbumArtworkFor(album: Album, completion: @escaping (UIImage?) -> Void) {
        guard let path = album.artworkURL?.absoluteString else { return }
        self.container
            .reference(withPath: path)
            .downloadURL { url, _ in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let _data = data else { return }
                    guard let uiimage = UIImage(data: _data) else { return }
                    completion(uiimage)
                }
                task.resume()
            }
    }
    
    
    
    
    public func deleteAlbumArtwork(_ album: Album, completion: @escaping (Error?) -> Void) {
        let path = "\(ContainerNames.artists)/\(album.artistID)/\(album.id)/\(SuffixNames.albumArtworkPNG)"
        container
            .reference(withPath: path)
            .delete { error in
                if error != nil {
                    print("Error deleting album artwork in Firebase Storage: \(error!)")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
    
    
    
    
    // MARK: User profile storage methods
    
    public func uploadUserProfilePicture(user: User, image: UIImage?, completion: @escaping (Bool) -> Void) {
//        let path = "\(ContainerNames.profilePictures)/\(user.email.underscoredDotAt())/\(SuffixNames.photoPNG)"
        
        guard let path = user.profilePictureURL?.absoluteString else { return }
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false); return }
                completion(true)
            }
    }
        
    
    public func downloadProfilePictureFor(user: User, completion: @escaping (UIImage?) -> Void) {
        guard let path = user.profilePictureURL?.absoluteString else { return }
        container
            .reference(withPath: path)
            .downloadURL { url, _ in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let _data = data else { return }
                    guard let uiimage = UIImage(data: _data) else { return }
                    completion(uiimage)
                }
                task.resume()
            }
    }
    
    
    
    
    
    
    // MARK: Artist image methods
    
    public func uploadArtistBioImage(_ image: UIImage?, artist: Artist, completion: @escaping (Bool, Error?) -> Void) {
//        let path = "\(ContainerNames.artists)/\(artist.id.uuidString)/\(SuffixNames.bioPicture)"
        guard let path = artist.imageURL?.absoluteString else { return }
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false, error); return }
                completion(true, nil)
            }
    }
    
    
    public func downloadArtistBioImage(artist: Artist, completion: @escaping (UIImage?) -> Void) {
//        let path = "\(ContainerNames.artists)/\(artist.id.uuidString)/\(SuffixNames.bioPicture)"
        guard let path = artist.imageURL?.absoluteString else { return }
        self.container
            .reference(withPath: path)
            .downloadURL { url, _ in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let _data = data else { return }
                    guard let uiimage = UIImage(data: _data) else { return }
                    completion(uiimage)
                }
                task.resume()
            }
    }
    
    
    
    
    
    
    // Universal upload image
    public func upload(image: UIImage?, path: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false, error); return }
                print("Image successfully uploaded to Firebase Storage.")
                completion(true, nil)
            }
    }
    
    
    // Universal download image
    public func downloadImageWith(path: String, completion: @escaping (UIImage?, URLResponse?, Error?) -> Void) {
        self.container
            .reference(withPath: path)
            .downloadURL { url, error in
                guard let url = url, error != nil else {
                    print("Error downloading image from Firebase storage.")
                    completion(nil, nil, error)
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let _data = data, let uiimage = UIImage(data: _data) else { return }
                    print("Image downloaded from Firebase storage successfully.")
                    completion(uiimage, response, error)
                }
                task.resume()
            }
    }
    
    // Universal delet image
    public func deleteImageAt(path: String, completion: @escaping (Error?) -> Void) {
        container
            .reference(withPath: path)
            .delete { error in
                guard error != nil else {
                    print("Error deleting image in Firebase Storage: \(error!)")
                    completion(error)
                    return
                }
                print("Deleting image successful.")
                completion(nil)
            }
    }
    
}

