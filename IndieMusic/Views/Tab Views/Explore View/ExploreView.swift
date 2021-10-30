//
//  ExploreView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

// Attributions
//<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
//
//<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
//
//<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
//
//<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
//
//<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>


import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var exploreVM: ExploreViewModel
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if #available(iOS 15, *) {
                    Text(vm.searchText)
                        .searchable(text: $exploreVM.searchText, prompt: "Search and explore!")
                } else {
                    SearchBar(text: $exploreVM.searchText)
                }
                
                // ARTISTS
                if !exploreVM.artists.isEmpty {
                    artistGridView
                    Divider()
                }
                
                //ALBUMS
                if !exploreVM.albums.isEmpty {
                    albumsGridView
                    Divider()
                }
                
                //GENRES
                if !exploreVM.genreOfAlbums.isEmpty {
                    genreGridView
                    Divider()
                }
                
                // SONGS
                if !exploreVM.songs.isEmpty {
                    songListView
                }
                
            }
        }
    }
}



extension ExploreView {
    
    private func getArtistGridRows() -> [GridItem] {
        switch exploreVM.artists.count {
        case 1:
            return [GridItem(.flexible())]
        case 2:
            return [GridItem(.flexible()), GridItem(.flexible())]
        default:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    
    var artistGridView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Artists")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm)
                } label: {
                    Text("See All")
                        .foregroundColor(Color.theme.primary)
                        .padding(.trailing)
                }
            }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: getArtistGridRows()) {
                        ForEach(exploreVM.artists, id: \.self) { artist in
                            ArtistNavLinkCell(artist: artist)
                                .frame(width: UIScreen.main.bounds.width * 0.90)
                                .environmentObject(vm)
                        }
                    }
                }
            }
            .frame(minHeight: 180)
            .padding(.leading)
        }
    }
    
    var albumsGridView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Albums")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    AlbumsView(albums: exploreVM.albums)
                        .environmentObject(vm)
                } label: {
                    Text("See All")
                        .foregroundColor(Color.theme.primary)
                        .padding(.trailing)
                }
            }.padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(exploreVM.albums.sorted(), id: \.self) { album in
                        AlbumNavLinkCellView(album: album)
                            .frame(width: UIScreen.main.bounds.width / 2.3)
                            .environmentObject(vm)
                    }
                }
            }.padding(.leading)
        }
    }
    
    var genreGridView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Genres")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    GenresListView(genres: exploreVM.genreOfAlbums)
                } label: {
                    Text("See All")
                        .foregroundColor(Color.theme.primary)
                        .padding(.trailing)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(Array(zip(exploreVM.genreOfAlbums.keys, Array(exploreVM.genreOfAlbums.values))), id: \.0) { genre, albums in
                        GenreNavLinkCellView(imageName: genre.underscoredLowercased(), title: genre, albums: albums)
                            .frame(width: UIScreen.main.bounds.width / 3.3, height: 100)
                            .environmentObject(vm)
                            .preference(key: GenreOfAlbumsIndexPreferenceKey.self, value: albums)
                    }
                }
            }
        }
         
    }
    
    var songListView: some View {
        VStack {
            HStack {
                Text("Songs")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    SongsListView(songs: exploreVM.songs, album: nil).environmentObject(vm)
                } label: {
                    Text("See All")
                        .foregroundColor(Color.theme.primary)
                        .padding(.trailing)
                }
            }
            
            List {
                ForEach(exploreVM.songs.sorted(), id: \.self) { song in
                    SongListCell(song: song, selectedSongCell: $vm.selectedSongCell)
                }
            }.listStyle(PlainListStyle())
        }
    }
    
}




struct GenreOfAlbumsIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [Album] = []
    
    static func reduce(value: inout [Album], nextValue: () -> [Album]) {
        value = nextValue()
    }
    
}




struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabView {
                NavigationView {
                    ExploreView()
                        .environmentObject(dev.mainVM)
                        .environmentObject(dev.exploreVM)
                        .environmentObject(dev.currentlyPlaingVM)
                        .navigationTitle(Text("Explore"))
                }.tabItem {
                    Label("Explore", systemImage: "flashlight.on.fill")
                }
            }
            
            TabView {
                NavigationView {
                    ExploreView()
                        .environmentObject(dev.mainVM)
                        .environmentObject(dev.exploreVM)
                        .environmentObject(dev.currentlyPlaingVM)
                        .preferredColorScheme(.dark)
                        .navigationTitle(Text("Explore"))
                }.tabItem {
                    Label("Explore", systemImage: "flashlight.on.fill")
                }
            }
        }
    }
}
