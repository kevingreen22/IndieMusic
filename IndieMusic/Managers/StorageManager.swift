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
    
    
    
    
    
    
    
    // MARK: MP3 storage methods
    
    public func upload(song: Song, localFilePath: URL?, completion: @escaping (StorageTaskSnapshot) -> Void) {
        // File located on disk
        guard let localFilePath = localFilePath else { return }
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"

        let ref = container.reference().child("\(ContainerNames.artists)/\(song.artistID)/\(song.albumID)/\(song.id)\(SuffixNames.mp3)")
        
        let task = ref.putFile(from: localFilePath, metadata: metadata)
        
        
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
                if let error = error {
                    completion(error)
                }
            }
    }
    
    
    
    
    
    
    // MARK: Album artwork storage methods
    
    public func uploadAlbumArtworkImage(album: Album, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let pngData = image?.pngData() else { return }
        let path = "\(ContainerNames.artists)/\(album.artistID)/\(album.id)/\(SuffixNames.albumArtworkPNG)"
        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false); return }
                completion(true)
            }
    }
    
    
    public func downloadAlbumArtwork(for albumID: String, completion: @escaping (UIImage?) -> Void) {
        DatabaseManger.shared.getAlbumWith(id: albumID) { album in
            guard let album = album else { return }
            
            let path = "\(ContainerNames.artists)/\(album.artistID)/\(album.id)/\(SuffixNames.albumArtworkPNG)"
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
    }
    
    
    
    
    
    
    // MARK: User profile storage methods
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = "\(ContainerNames.profilePictures)/\(email.underscoredDotAt())/\(SuffixNames.photoPNG)"
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: path)
            .putData(pngData, metadata: nil) { metaData, error in
                guard metaData != nil, error == nil else { completion(false); return }
                completion(true)
            }
        
    }
    
    
    public func downloadURLForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container
            .reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    
    
    
    
}

