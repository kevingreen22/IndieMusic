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
    @StateObject var exploreVM = ExploreViewModel()
    
    let colums = [GridItem(.flexible(minimum: ExploreViewModel.gridCellSize))]
    let rows = [GridItem(.flexible(minimum: ExploreViewModel.gridCellSize))]
    
    
    var body: some View {
        ScrollView {
            VStack {
                if #available(iOS 15, *) {
                    Text(vm.searchText)
                        .searchable(text: $exploreVM.searchText, prompt: "Search and explore!")
                } else {
                    SearchBar(text: $exploreVM.searchText)
                }
                
                Divider()
                
                // ARTISTS
                GridWithTitleAndSeeAll(
                    title: "Artists",
                    destination:
                        ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm),
                    grid:
                        artistGridView()
                )
                
                Divider()
                
                //ALBUMS
                GridWithTitleAndSeeAll(
                    title: "Albums",
                    destination:
                        AlbumsView(albums: exploreVM.albums.sorted()).environmentObject(vm),
                    grid: albumsGridView()
                )
                
                Divider()
                
                //GENRES
                GridWithTitleAndSeeAll(
                    title: "Genres",
                    destination: AlbumsView(albums: exploreVM.albumsForGenre).environmentObject(vm),
                    grid: genreGridView()
                ).onPreferenceChange(GenreOfAlbumsIndexPreferenceKey.self) { value in
                    exploreVM.albumsForGenre = value
                }
                
                Divider()
                
                // SONGS
                GridWithTitleAndSeeAll(
                    title: "Songs",
                    destination: EmptyView(),
                    isActive: false,
                    grid: songListView()
                )
            }
        }
        
        .onAppear {
            exploreVM.fetchExplores()
        }
        
    }
}



extension ExploreView {
    
    func GridWithTitleAndSeeAll<Dest: View, Grid: View>(title: String, destination: Dest, isActive: Bool = false, grid: Grid) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                
                NavigationLink(isActive: .constant(isActive)) {
                    destination
                } label: {
                    Text("See All")
                        .foregroundColor(.mainApp)
                        .padding(.trailing)
                }
            }
            grid
        }
    }
    
    func artistGridView() -> some View {
        LazyHGrid(rows: rows) {
            ForEach(exploreVM.artists.sorted(), id: \.self) { artist in
                ArtistNavLinkCell(artist: artist)
                    .environmentObject(vm)
            }
        }
    }
    
    func albumsGridView() -> some View {
        LazyHGrid(rows: rows) {
            ForEach(exploreVM.albums.sorted(), id: \.self) { album in
                AlbumNavLinkCellView(album: album)
                    .environmentObject(vm)
            }
        }
    }
    
    func genreGridView() -> some View {
        LazyHGrid(rows: rows) {
            let genre = exploreVM.genreOfAlbums.map{$0.key}.sorted()
            ForEach(genre.indices) { index in
                ExploreCellView(image: nil, title: genre[index], altText: nil)
                    .environmentObject(vm)
                    .preference(key: GenreOfAlbumsIndexPreferenceKey.self, value: exploreVM.genreOfAlbums.map{$0.value}[index])
            }
        }
    }
    
    func songListView() -> some View {
        List {
            ForEach(exploreVM.songs.sorted(), id: \.self) { song in
                SongListCell(song: song, selectedSongCell: .constant(nil))
            }
        }.listStyle(DefaultListStyle())
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
        ExploreView()
            .environmentObject(MainViewModel())
            .environmentObject(ExploreViewModel())
    }
}
