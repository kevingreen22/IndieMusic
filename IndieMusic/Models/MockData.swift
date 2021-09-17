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
                           favoriteAlbums: [data.first!.albums!.first!],
                           favoriteSongs: [data.first!.albums!.first!.songs.first!],
                           recentlyAdded: nil,
                           artist: data.first!
    )
    
    
    // MARK: Artist mock data
    static let data: [Artist] = [
        Artist(name: "Brokeneck",
               genre: "Metal",
               imageURL: nil,
               albums: [
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "dillinger"),
                      songs: [
                        Song(title: "Electric Sloth",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Penguins Are Awfly Cute",
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
                      artworkURL: URL(string: "dillinger"),
                      songs: [
                        Song(title: "Electric Sloth",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Penguins Are Awfly Cute",
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
                      artworkURL: URL(string: "dillinger"),
                      songs: [
                        Song(title: "Electric Sloth",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Penguins Are Awfly Cute",
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
                      artworkURL: URL(string: "dillinger"),
                      songs: [
                        Song(title: "Electric Sloth",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh falkia \nlsijfa sdihf\n aslkdh alsdh falshd f;lasj f;aliewhj\nasidcha'osicnma\n.wkenc :SOIHje\nf:as ;diafh awsoiafha sidhaf ;owiehjf\n ao aois doiah sohf asohf;alweiUS:LW  OIje \n:OSIHJw e;aliawh\n a;oij :Oijaw;oIW\n E:O ASOIEHJF ;woe\n WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Penguins Are Awfly Cute",
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
        var artistNames: [Artist] = []
        for artist in data {
            artistNames.append(artist)
        }
        
        return artistNames
    }
    
    static func Albums() -> [Album] {
        var albumNames: [Album] = []
        for artist in data {
            for album in artist.albums! {
                albumNames.append(album)
            }
        }
        
        return albumNames
    }
    
    static func Songs() -> [Song] {
        var songs: [Song] = []
        for artist in data {
            for album in artist.albums! {
                for song in album.songs {
                    songs.append(song)
                }
            }
        }

        return songs
    }
    
    
    
    // MARK: Explore mock data
    static let exploreData: [ExploreCellModel] = [
        ExploreCellModel(imageName: "metal", genre: "Metal", artists: Artists()),
        ExploreCellModel(imageName: "r&b", genre: "R&B", artists: Artists()),
        ExploreCellModel(imageName: "hip_hop", genre: "Hip Hop", artists: Artists()),
        ExploreCellModel(imageName: "rap", genre: "Rap", artists: Artists()),
        ExploreCellModel(imageName: "blues", genre: "Blues", artists: Artists())
    ]
    
    
    
    static let mockAlbums = ["Album 1", "Album 2", "Album 3", "Album 4"]
    
}
