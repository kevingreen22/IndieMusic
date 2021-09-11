//
//  DatabaseManager.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    
    
    
    
    // MARK: User database methods

    /// Inserts a User to the database.
    public func insert(user: User, completion: @escaping (Bool) -> Void) {
        let documentID = user.email.underscoredDotAt()
        do {
        try database
            .collection(ContainerNames.users)
            .document(documentID)
            .setData(from: user) { error in
                completion(error == nil)
            }
        } catch let error {
            print("Error writing \"user\" to Firestore: \(error.localizedDescription)")
        }
    }
    
    
    public func getUser(email: String, completion: @escaping (User?) -> Void) {
        let documentID = email.underscoredDotAt()
        var _user: User?
        database
            .collection(ContainerNames.users)
            .document(documentID)
            .getDocument { snapshot, error in
                guard error == nil else {
                    return
                }
                let result = Result {
                    try snapshot?.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        // A `Artist` value was successfully initialized from the DocumentSnapshot.
                        print("User: \(user)")
                        _user = user
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `User` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding artist: \(error)")
                }
                
                completion(_user)
            }
    }
    
        
    public func updateProfilePhotoData(email: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        let id = email.underscoredDotAt()
        
        guard let photoData = image.pngData() else { return } 
        
        let dbRef = database
            .collection(ContainerNames.users)
            .document(id)
        
        dbRef.updateData(["profile_photo" : photoData], completion: { error in
            guard error == nil else  {
                print("Error updating document: \(String(describing: error))")
                return
            }
            print("Profile photo ref successfully updated for user")
            
        })
        
    }
    
    
    /// Removes a user from the database.
    public func delete(user: User, completion: @escaping (Bool) -> Void) {
        let documentID = user.email.underscoredDotAt()
        database
            .collection(ContainerNames.users)
            .document(documentID)
            .delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }
    
    
    
    
    
    
    // MARK: Insert music to database
    
    /// Adds an artist to the Firestore database.
    public func insert(artist: Artist, completion: @escaping (Bool) -> Void) {
        let documentID = artist.id

        do {
            try database
                .collection(ContainerNames.artists)
                .document(documentID)
                .setData(from: artist) { [weak self] error in
//                    guard error == nil else { completion(error == nil); return }
//                    for album in artist.albums {
//                        self?.insert(album: album, completion: { success in
//                            print("Error saving album into database: \(String(describing: error.debugDescription))")
//                        })
//                    }
                    completion(error == nil)
                }
            
        } catch let error {
            print("Error writing \"artist\" to Firestore: \(error.localizedDescription)")
        }
    }
    
    
    /// Adds an album to the Firestore database.
    public func insert(album: Album, completion: @escaping (Bool) -> Void) {
        let documentID = album.id
        
        do {
            try database
                .collection(ContainerNames.albums)
                .document(documentID)
                .setData(from: album) { error in
                    completion(error == nil)
                }
            
        } catch let error {
            print("Error writing \"album\" to Firestore: \(error.localizedDescription)")
        }
    }
    
    
    /// Adds a song to the Firestore database.
    public func insert(song: Song, completion: @escaping (Bool) -> Void) {
        let documentID = song.id

        do {
            try database
                .collection(ContainerNames.songs)
                .document(documentID)
                .setData(from: song) { error in
                    completion(error == nil)
                }
            
        } catch let error {
            print("Error writing \"song\" to Firestore: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    
    // MARK: Get music from database
    
    /// Gets all artists.
    public func getAllArtists(completion: @escaping ([Artist]) -> Void) {
        var artists: [Artist] = []
        database
            .collection(ContainerNames.artists)
            .getDocuments { snapshot, error in
//                guard let documents = snapshot?.documents.compactMap({ $0.data() }), error == nil else { return }
//                let artists: [Artist] = documents.compactMap({
//                    let name = $0["name"] as! String
//                    let albums = $0["albums"] as! [Album]
//                    let metaData = $0["metaData"] as? [String]
//
//                    return Artist(name: name, albums: albums, metaData: metaData)
//                })
//                print("retrieved artists: \(artists)")
                
                guard error == nil else { return }
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Artist.self)
                    }
                    switch result {
                    case .success(let artist):
                        if let artist = artist {
                            // A `Artist` value was successfully initialized from the DocumentSnapshot.
                            print("Artist: \(artist)")
                            artists.append(artist)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Artist` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding artist: \(error)")
                    }
                }
                
                completion(artists)
            }
    }
    
    /// Fetches the artist that matches the given ID if it exists.
    public func getArtist(with id: String, completion: @escaping (Artist?) -> Void) {
        var _artist: Artist?
        database
            .collection(ContainerNames.artists)
            .document(id)
            .getDocument { snapshot, error in
                guard error == nil else { return }
                let result = Result {
                    try snapshot?.data(as: Artist.self)
                }
                switch result {
                case .success(let artist):
                    if let artist = artist {
                        // A `Artist` value was successfully initialized from the DocumentSnapshot.
                        print("Artist: \(artist)")
                        _artist = artist
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `Artist` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding artist: \(error)")
                }
                
                completion(_artist)
            }
    }
    
    
    
    /// Gets all albums
    public func getAllAlbums(completion: @escaping ([Album]) -> Void) {
        var albums: [Album] = []
        database
            .collection(ContainerNames.albums)
            .getDocuments { snapshot, error in
//                guard let documents = snapshot?.documents.compactMap({ $0.data() }), error == nil else { return }
//                let albums: [Album] = documents.compactMap({
//                    let title = $0["title"] as! String
//                    let artistName = $0["artistName"] as! String
//                    let artistID = $0["artistID"] as! String
//                    let artworkURL = $0["artworkURL"] as? URL
//                    let year = $0["year"] as! String
//                    let genre = $0["genre"] as! String
//                    let metaData = $0["metaData"] as? [String]
//
//                    return Album(title: title, artistName: artistName, artistID: artistID, artworkURL: artworkURL, year: year, genre: genre, metaData: metaData)
//                })
//                print("retrieved albums: \(albums)")
                
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Album.self)
                    }
                    switch result {
                    case .success(let album):
                        if let album = album {
                            // A `Album` value was successfully initialized from the DocumentSnapshot.
                            print("Album: \(album)")
                            albums.append(album)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Album` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding album: \(error)")
                    }
                }
                
                completion(albums)
            }
    }
    
    /// Gets all albums, for an artist.
    public func getAlbumsFor(artist id: String, completion: @escaping ([Album]) -> Void) {
        var albums: [Album] = []
        database
            .collection(ContainerNames.albums)
            .document(id)
//            .whereField("artistID", isEqualTo: id)
            .getDocument(completion: { snapshot, error in
//                guard let documents = snapshot?.documents.compactMap({ $0.data() }), error == nil else { return }
//                let albums: [Album] = documents.compactMap({
//                    let title = $0["title"] as! String
//                    let artistName = $0["artistName"] as! String
//                    let artistID = $0["artistID"] as! String
//                    let artworkURL = $0["artworkURL"] as? URL
//                    let songs = $0["songs"] as! [Song]
//                    let year = $0["year"] as! String
//                    let genre = $0["genre"] as! String
//                    let metaData = $0["metaData"] as? [String]
//
//                    return Album(title: title, artistName: artistName, artistID: artistID, artworkURL: artworkURL, songs: songs, year: year, genre: genre, metaData: metaData)
//                })
//                print("retrieved albums: \(albums)")
                
                guard error == nil else { return }
                let result = Result {
                    try snapshot?.data(as: Album.self)
                }
                switch result {
                case .success(let album):
                    if let album = album {
                        // A `Album` value was successfully initialized from the DocumentSnapshot.
                        print("Album: \(album)")
                        albums.append(album)
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `Album` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding album: \(error)")
                }
                
                completion(albums)
            })
    }
    
    /// Fetches one album that matches the given ID if it exists
    public func getAlbumWith(id: String, completion: @escaping (Album?) -> Void) {
        var albm: Album?
        database
            .collection(ContainerNames.albums)
            .whereField("id", isEqualTo: id)
            .getDocuments(completion: { snapshot, error in
                guard error == nil else { return }
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Album.self)
                    }
                    switch result {
                    case .success(let album):
                        if let _album = album {
                            // A `Album` value was successfully initialized from the DocumentSnapshot.
                            print("Album: \(String(describing: album))")
                            albm = _album
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Album` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding album: \(error)")
                    }
                }
                
                completion(albm)
            })
    }
    
    
    
    
    
    
    /// Fetches all songs.
    public func getAllSongs(completion: @escaping ([Song]) -> Void) {
        var songs: [Song] = []
        database
            .collection(ContainerNames.songs)
            .getDocuments { snapshot, error in
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Song.self)
                    }
                    switch result {
                    case .success(let song):
                        if let song = song {
                            // A `Song` value was successfully initialized from the DocumentSnapshot.
                            print("Song: \(song)")
                            songs.append(song)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Album` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding song: \(error)")
                    }
                }
                
                completion(songs)
            }
    }
    
    /// Fetches all songs for an album.
    public func getSongsFor(album id: String, completion: @escaping ([Song]) -> Void) {
        var songs: [Song] = []
        database
            .collection(ContainerNames.songs)
            .whereField("albumID", isEqualTo: id)
            .getDocuments { snapshot, error in
                for document in snapshot!.documents {
                    let result = Result {
                        try document.data(as: Song.self)
                    }
                    switch result {
                    case .success(let song):
                        if let song = song {
                            // A `Song` value was successfully initialized from the DocumentSnapshot.
                            print("Song: \(song)")
                            songs.append(song)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Album` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding song: \(error)")
                    }
                }
                
                completion(songs)
            }
    }
    
    /// Fetches one song that matches the given ID if it exists.
    public func getSong(with id: String, completion: @escaping (Song?) -> Void) {
        var _song: Song?
        database
            .collection(ContainerNames.songs)
            .document(id)
            .getDocument { snapshot, error in
                let result = Result {
                    try snapshot?.data(as: Song.self)
                }
                switch result {
                case .success(let song):
                    if let song = song {
                        // A `Song` value was successfully initialized from the DocumentSnapshot.
                        print("Song: \(song)")
                        _song = song
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `Album` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding song: \(error)")
                }
                
                completion(_song)
            }
    }
    
    
    
    
    
}
