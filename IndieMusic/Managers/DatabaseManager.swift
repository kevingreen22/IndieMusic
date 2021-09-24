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

    /// Inserts a new User to the database.
    public func insert(user: User, completion: @escaping (Bool) -> Void) {
        let documentID = user.email.underscoredDotAt()
        do {
            try database
                .collection(ContainerNames.users)
                .document(documentID)
                .setData(from: user) { [weak self] error in
                    completion(error == nil)
                }
        } catch let error {
            print("Error writing \"user\" to Firestore: \(error)")
        }
    }
    
    
    /// Updates a User in the database.
    public func update(user: User, completion: @escaping (Bool, Error?) -> Void) {
        let documentID = user.email.underscoredDotAt()

        do {
            try database
                .collection(ContainerNames.users)
                .document(documentID)
                .setData(from: user) { [weak self] error in
                    if let error = error {
                        print("Error updating User in Firestore DB: \(error)")
                        completion(false, error)
                    } else {
                        print("Updating User in Firestore DB successfull.")
                        completion(true, nil)
                    }
                }
        } catch let error {
            print("Error writing \"user\" to Firestore: \(error)")
        }
    }

    
    public func fetchUser(email: String, completion: @escaping (User?) -> Void) {
        let documentID = email.underscoredDotAt()
        var _user: User?
        database
            .collection(ContainerNames.users)
            .document(documentID)
            .getDocument { [weak self] snapshot, error in
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
                        print("Fetching User successful.")
                        _user = user
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                        print("Document 'User' with email: \(email), does not exist")
                    }
                case .failure(let error):
                    // A `User` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding artist: \(error)")
                }
                
                completion(_user)
            }
    }
    
        
    // THIS DOESNT WORK BECAUSE THE IMAGE DATA IS TO LARGE FOR THE DATABASE
    public func updateProfilePhotoData(email: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        let documentID = email.underscoredDotAt()
        
        guard let photoData = image.pngData() else { return } 
        
        let dbRef = database
            .collection(ContainerNames.users)
            .document(documentID)
        
        dbRef.updateData(["profile_photo" : photoData], completion: { [weak self] error in
            guard error == nil else  {
                print("Error updating document: \(error.debugDescription))")
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
            .delete() { [weak self] error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }
    
    
    
    
    
    
    // MARK: Insert music to database
    
    /// Adds an artist to the Firestore database. Either overwriting the current artist with a new instance, or creating a new one.
    public func insert(artist: Artist, completion: @escaping (Bool) -> Void) {
        let documentID = artist.id

        do {
            try database
                .collection(ContainerNames.artists)
                .document(documentID)
                .setData(from: artist) { [weak self] error in
                    completion(error == nil)
                }
        } catch let error {
            print("Error writing \"artist\" to Firestore: \(error.localizedDescription)")
        }
    }
    
    
    /// Adds album(s) to the artist within the Firestore database.
    public func insert(albums: [Album], for artist: Artist, completion: @escaping (Error?) -> Void) {
        let documentID = artist.id
        
        database
            .collection(ContainerNames.artists)
            .document(documentID)
            .updateData([
                "albums" : FieldValue.arrayUnion([albums])
            ]) { [weak self] error in
                guard error != nil else {
                    completion(nil)
                    return
                }
                print("Error writing \"album\" to artist within Firestore: \(error!.localizedDescription))")
                completion(error)
            }
    }
    
    
    /// Adds song(s) to an artist's album within the Firestore database.
    public func insert(song: Song, completion: @escaping (Error?) -> Void) {
        
            database
                .collection(ContainerNames.artists)
                .document(song.artistID)
                .updateData([
                    "albums" : [
                        "songs" : FieldValue.arrayUnion([song])
                    ]
                ]) { [weak self] error in
                    guard error != nil else {
                        completion(nil)
                        return
                    }
                    print("Error writing \"song\" to Firestore: \(error!.localizedDescription))")
                    completion(error)
                }
    }
    
    
    
    
    
    
    
    
    // MARK: Get music from database
    
    /// Gets all artists.
    public func fetchAllArtists(completion: @escaping ([Artist]) -> Void) {
        var _artists: [Artist] = []
        database
            .collection(ContainerNames.artists)
            .getDocuments { [weak self] snapshot, error in
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
                            _artists.append(artist)
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot, or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `Artist` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding artist: \(error)")
                    }
                }
                
                completion(_artists)
            }
    }
    
    /// Fetches the artist that matches the given ID if it exists.
    public func fetchArtist(with id: String, completion: @escaping (Artist?) -> Void) {
        var _artist: Artist?
        database
            .collection(ContainerNames.artists)
            .document(id)
            .getDocument { [weak self] snapshot, error in
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
    public func fetchAllAlbums(completion: @escaping ([Album]) -> Void) {
        var _albums: [Album] = []
        
        fetchAllArtists { artists in
            for artist in artists {
                if let albums = artist.albums {
                    for album in albums {
                        _albums.append(album)
                    }
                }
            }
            completion(_albums)
        }
    }
    
    /// Gets all albums, for an artist.
    public func fetchAlbumsFor(artistID id: String, completion: @escaping ([Album]?) -> Void) {
        fetchArtist(with: id) { artist in
            guard let artist = artist else { completion(nil); return }
            guard let albums = artist.albums else { completion(nil); return }
            completion(albums)
        }
    }
    
    /// Fetches one album that matches the given ID if it exists
    public func fetchAlbumWith(id: String, artistID: String, completion: @escaping (Album?) -> Void) {
        fetchArtist(with: artistID) { artist in
            guard let artist = artist else { completion(nil); return }
            guard let albums = artist.albums else { completion(nil); return }
            for album in albums {
                if album.id == id {
                    completion(album)
                    return
                }
            }
        }
    }
    
    
    
    /// Fetches all songs.
    public func fetchAllSongs(completion: @escaping ([Song]) -> Void) {
        var _songs: [Song] = []
        
        fetchAllArtists { artists in
            for artist in artists {
                if let albums = artist.albums {
                    for album in albums {
                        _songs.append(contentsOf: album.songs)
                    }
                }
            }
            completion(_songs)
        }
    }
    
    /// Fetches all songs for an album.
    public func fetchSongsFor(albumID id: String, artistID: String, completion: @escaping ([Song]?) -> Void) {
        fetchAlbumWith(id: id, artistID: artistID) { album in
            guard let album = album else { completion(nil); return }
            completion(album.songs)
        }
    }
    
    /// Fetches one song that matches the given ID if it exists.
    public func fetchSong(with id: String, albumID: String, artistID: String, completion: @escaping (Song?) -> Void) {
        fetchAlbumWith(id: albumID, artistID: artistID) { album in
            guard let album = album else { completion(nil); return }
            for song in album.songs {
                if song.id == id {
                    completion(song)
                    return
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: Delete music from database
    public func delete(artist: Artist, completion: @escaping (Bool, Error?) -> Void) {
        let documentID = artist.id
        
        database
            .collection(ContainerNames.artists)
            .document(documentID)
            .delete { error in
                if let error = error {
                    print("Error deleting Artist from Firestore DB: \(error)")
                    completion(false, error)
                } else  {
                    print("Artist successfully deleted from Firebase DB.")
                }
            }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Add new genre to database
    
    public func addNewGenre(_ genre: String, completion: @escaping (Bool) -> Void) {
        database
            .collection(ContainerNames.users)
            .document("genres")
            .updateData(["genre" : genre], completion: { [weak self] error in
                guard error == nil else  {
                    print("Error updating genres: \(error.debugDescription)")
                    completion(true)
                    return
                }
                completion(true)
                print("Genre successfully added.")
            })
    }
    
    
    public func fetchGenres(completion: @escaping ([String]?, Error?) -> Void) {
        database
            .collection(ContainerNames.genres)
            .document("genres")
            .getDocument { [weak self] snapshot, error in
                guard error == nil else { return }
                guard let genres: [String] = snapshot?.get("genre") as? [String] else {
                    print("Fetching genres failied")
                    completion(nil, error)
                    return
                }
                
                print("Genres fetched successfully")
                completion(genres, nil)
            }
    }
    
    
    
    
    
    
    
}
