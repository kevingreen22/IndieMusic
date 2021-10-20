//
//  MockData.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import Foundation

// MARK: MOCKDATA
class MockData {
    
    // MARK: User mock data
    static let user = User(name: "Kevin",
                           email: "Bbongrip@gmail.com",
                           profilePictureURL: nil,
                           profilePictureData: nil,
                           songListData: [],
                           favoriteArtists: [data.first!],
                           favoriteAlbums: [data.first!.albums.first!],
                           favoriteSongs: [data.first!.albums.first!.songs.first!],
                           recentlyAdded: nil,
                           artist: data.first!
    )
    
    
    // MARK: Artist mock data
    static let data: [Artist] = [
        Artist(name: "Brokeneck",
               genre: "Metal",
               imageURL: URL(string: "artists/35C17CAF-9B6C-4CBC-AA66-C19F2442612E/artist_photo.png"),
               albums: [
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "artists/35C17CAF-9B6C-4CBC-AA66-C19F2442612E/42007443-CA23-4E4E-9CC3-983E41F90A14/album_artwork.png"),
                      songs: [
                        Song(title: "Electric Sloth",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Penguins Are Awfly Cute",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: nil,
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                      ],
                      year: "2009",
                      genre: "Metal"),
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "artists/35C17CAF-9B6C-4CBC-AA66-C19F2442612E/42007443-CA23-4E4E-9CC3-983E41F90A14/album_artwork.png"),
                      songs: [
                        Song(title: "Electric Sloth",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Penguins Are Awfly Cute",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: nil,
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                      ],
                      year: "2009",
                      genre: "Metal"),
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "artists/35C17CAF-9B6C-4CBC-AA66-C19F2442612E/42007443-CA23-4E4E-9CC3-983E41F90A14/album_artwork.png"),
                      songs: [
                        Song(title: "Electric Sloth",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Penguins Are Awfly Cute",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: nil,
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                      ],
                      year: "2009",
                      genre: "Metal"),
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "artists/35C17CAF-9B6C-4CBC-AA66-C19F2442612E/42007443-CA23-4E4E-9CC3-983E41F90A14/album_artwork.png"),
                      songs: [
                        Song(title: "Electric Sloth",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                        
                        Song(title: "Penguins Are Awfly Cute",
                             albumTitle: "Hellfest EP",
                             artistName: "Brokeneck",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: nil,
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                            ),
                      ],
                      year: "2009",
                      genre: "Metal")
               ]
              ),
    ]
    
    static func Artists() -> [Artist] {
        var artists: [Artist] = []
        for artist in data {
            artists.append(artist)
        }
        
        return artists
    }
    
    static func Albums() -> [Album] {
        var albumNames: [Album] = []
        for artist in data {
            for album in artist.albums {
                albumNames.append(album)
            }
        }
        
        return albumNames
    }
    
    static func Songs() -> [Song] {
        var songs: [Song] = []
        for artist in data {
            for album in artist.albums {
                for song in album.songs {
                    songs.append(song)
                }
            }
        }
        
        return songs
    }
    
    static func GenresOfAlbums() -> [String : [Album]] {
        var genreOfAlbums: [String : [Album]] = [:]
        for artist in data {
            for album in artist.albums {
                genreOfAlbums.updateValue(artist.albums, forKey: album.genre)
//                genreOfAlbums[album.genre]?.append(album)
            }
        }
        
        return genreOfAlbums
    }
    
    static func Genres() -> [String] {
        var genres: [String] = []
        for artist in data {
            for album in artist.albums {
                genres.append(album.genre)
            }
        }
        
        return genres
    }
    
    
    // MARK: Explore mock data
    static let exploreData: [ExploreCellModel] = [
        ExploreCellModel(imageName: "metal", image: nil, genre: "Metal", albums: Albums(), artists: Artists()),
        ExploreCellModel(imageName: "r&b", image: nil, genre: "R&B", albums: Albums(), artists: Artists()),
        ExploreCellModel(imageName: "hip_hop", image: nil, genre: "Hip Hop", albums: Albums(), artists: Artists()),
        ExploreCellModel(imageName: "rap", image: nil, genre: "Rap", albums: Albums(), artists: Artists()),
        ExploreCellModel(imageName: "blues", image: nil, genre: "Blues", albums: Albums(), artists: Artists())
    ]
    
    
    
    static let mockAlbums = ["Album 1", "Album 2", "Album 3", "Album 4"]
    
}
