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
                           profilePictureRef: nil,
                           favoriteArtists: [data.first!],
                           favoriteAlbums: [data.first!.albums!.first!],
                           favoriteSongs: [data.first!.albums!.first!.songs.first!],
                           recentlyAdded: nil,
                           isArtistOwner: true,
                           artist: data.first!
    )
    
    
    // MARK: Artist mock data
    static let data: [Artist] = [
        Artist(name: "Brokeneck",
               genre: "Metal",
               albums: [
                Album(title: "Hellfest EP", artistName: "Brokeneck", artistID: UUID().uuidString,
                      artworkURL: URL(string: "dillinger"),
                      songs: [
                        Song(title: "Electric Sloth",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh;falkia l;sijfa s;dihf a;slkdh alsdh falshd f;lasj f;aliewhj a;sidcha'osicnma,.wkenc :SOIHje f:as ;diafh awsoiafha sidhaf ;owiehjf ao aois doiah sodhf asohf;alweiUS:LW  OIje :OSIHJw e;aliawh a;oij :Oijaw;oIW E:O ASOIEHJF ;woe WEOIJ",
                             url: URL(fileURLWithPath: "song/path/name.mp3")
                        ),
                        
                        Song(title: "Crush, Kill, Destroy",
                             genre: "Metal",
                             artistID: UUID().uuidString,
                             albumID: UUID().uuidString,
                             lyrics: "jahsdh;falkia l;sijfa s;dihf a;slkdh alsdh falshd f;lasj f;aliewhj a;sidcha'osicnma,.wkenc :SOIHje f:as ;diafh awsoiafha sidhaf ;owiehjf ao aois doiah sodhf asohf;alweiUS:LW  OIje :OSIHJw e;aliawh a;oij :Oijaw;oIW E:O ASOIEHJF ;woe WEOIJ",
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
        ExploreCellModel(genre: "Metal", imageName: "metal", artists: Artists()),
        ExploreCellModel(genre: "R&B", imageName: "r&b", artists: Artists()),
        ExploreCellModel(genre: "Hip Hop", imageName: "hip_hop", artists: Artists()),
        ExploreCellModel(genre: "Rap", imageName: "rap", artists: Artists()),
        ExploreCellModel(genre: "Blues", imageName: "blues", artists: Artists())
    ]
    
    
    
    
    
}
