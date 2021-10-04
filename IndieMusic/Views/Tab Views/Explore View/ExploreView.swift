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
    @EnvironmentObject var vm: ViewModel
    @StateObject var exploreVM = ExploreViewModel()
    
    let colums = [GridItem(.flexible(minimum: 150))]
    let rows = [GridItem(.flexible(minimum: 150))]
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    if #available(iOS 15, *) {
                        Text(vm.searchText)
                            .searchable(text: $exploreVM.searchText, prompt: "Search and explore!")
                    } else {
                        SearchBar(text: $exploreVM.searchText)
                            .padding(.vertical)
                    }
                    
                    Divider()
                    
                    // ARTISTS
                    CellWithTitleAndSeeAll(
                        title: "Artists",
                        destination:
                            ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm),
                        grid:
                            artistGrid(rows: rows, artists: exploreVM.artists.sorted())
                    )
                    
                    Divider()
                    
                    //ALBUMS
                    CellWithTitleAndSeeAll(
                        title: "Albums",
                        destination:
                            AlbumsView(albums: exploreVM.albums.sorted()).environmentObject(vm),
                        grid:
                            albumsGrid(rows: rows, albums: exploreVM.albums.sorted())
                    )
                        
                    
                    Divider()
                    
                    //GENRES
                    CellWithTitleAndSeeAll(
                        title: "Genres",
                        destination:
                            AlbumsView(albums: exploreVM.genreOfAlbums.map{$0.value}[exploreVM.index])
                            .environmentObject(vm),
                        grid:
                            genreGrid(rows: rows, genreOfAlbums: exploreVM.genreOfAlbums)
                    ).onPreferenceChange(GenreOfAlbumsIndexPreferenceKey.self) { value in
                        exploreVM.index = value
                    }
                    
                    
                    Divider()
                    
                    // SONGS
                    List {
                        ForEach(exploreVM.songs.sorted(), id: \.self) { song in
                            SongListCell(albumArtwork: UIImage(), song: song, selectedSongCell: .constant(nil))
                        }
                    }.listStyle(DefaultListStyle())
                    
                }
            }
        }
        
        
        .onAppear {
            exploreVM.fetchExplores()
        }
        
    }
}



extension ExploreView {
    
    func CellWithTitleAndSeeAll<Dest: View, Grid: View>(title: String, destination: Dest, grid: Grid) -> some View {
        VStack {
            HStack {
                Text(title).font(.title)
                Spacer()
                NavigationLink(
                    destination: destination,
                    label: {
                        Text("See All").foregroundColor(.mainApp)
                    })
            }
            grid
        }
    }
    
    func albumsGrid(rows: [GridItem], albums: [Album]) -> some View {
        LazyHGrid(rows: rows) {
            ForEach(albums.sorted(), id: \.self) { album in
                AlbumNavLinkCellView(album: album)
                    .environmentObject(vm)
            }
        }
    }
    
    func artistGrid(rows: [GridItem], artists: [Artist]) -> some View {
        LazyHGrid(rows: rows) {
            ForEach(artists.sorted(), id: \.self) { artist in
                ArtistNavLinkCell(artist: artist)
                    .environmentObject(vm)
            }
        }
    }
    
    func genreGrid(rows: [GridItem], genreOfAlbums: [String: [Album]]) -> some View {
        LazyHGrid(rows: rows) {
            let genre = genreOfAlbums.map{$0.key}
            ForEach(genre.indices) { index in
                ExploreCellView(title: genre[index], image: nil)
                    .environmentObject(vm)
                    .preference(key: GenreOfAlbumsIndexPreferenceKey.self, value: index)
            }
        }
    }
    
}


struct GenreOfAlbumsIndexPreferenceKey: PreferenceKey {
    static var defaultValue: Int = 0
    
    static func reduce(value: inout Int, nextValue: () -> Int) {
        value = nextValue()
    }
    
}







struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(ViewModel())
            .environmentObject(ExploreViewModel())
    }
}
