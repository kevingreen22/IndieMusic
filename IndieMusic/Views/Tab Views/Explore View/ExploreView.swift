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
    
    let colums = [GridItem(.fixed(ExploreViewModel.gridCellSize))]
    let rows = [GridItem(.fixed(ExploreViewModel.gridCellSize))]
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if #available(iOS 15, *) {
                    Text(vm.searchText)
                        .searchable(text: $exploreVM.searchText, prompt: "Search and explore!")
                } else {
                    SearchBar(text: $exploreVM.searchText)
                }
                
//                Divider()
                
                // ARTISTS
//                GridWithTitleAndSeeAll(
//                    title: "Artists",
//                    destination:
//                        ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm),
//                    grid: artistGridView()
//                )
                
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
                ).onPreferenceChange(GenreOfAlbumsIndexPreferenceKey.self) { albums in
                    exploreVM.albumsForGenre = albums
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
                    .font(.title)
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
            }.padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                grid.padding(.horizontal)
            }.frame(maxHeight: 200)
        }
    }
    
    func artistGridView() -> some View {
        let rows = [GridItem(.flexible()),
                     GridItem(.flexible()),
                     GridItem(.flexible())
        ]

        return LazyHGrid(rows: rows) {
            ForEach(exploreVM.artists.sorted(), id: \.self) { artist in
                ArtistNavLinkCell(artist: artist)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 60)
                    .environmentObject(vm)
                    .backgroundForGrids()
            }
        }
    }
    
    func albumsGridView() -> some View {
        let rows = [GridItem(.flexible())]
        
        return LazyHGrid(rows: rows) {
            ForEach(exploreVM.albums.sorted(), id: \.self) { album in
                AlbumNavLinkCellView(album: album)
                    .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.width / 2.3)
                    .environmentObject(vm)
            }
        }.padding(.horizontal)
    }
    
    func genreGridView() -> some View {
        let rows = [GridItem(.flexible())]
        
        return LazyHGrid(rows: rows) {
            let genre = exploreVM.genreOfAlbums.keys.sorted()//.map{ $0.key }.sorted()
            ForEach(genre.indices) { index in
                ExploreCellView(image: nil, title: genre[index], altText: nil)
                    .frame(width: UIScreen.main.bounds.width / 2.3, height: 90)
                    .environmentObject(vm)
                    .preference(key: GenreOfAlbumsIndexPreferenceKey.self, value: exploreVM.genreOfAlbums.map{ $0.value }[index])
            }
        }.padding(.horizontal)
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


extension View {
    
    func backgroundForGrids() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary)
                .opacity(0.3)
                .scaleEffect(1.1)
                .shadow(radius: 8)
            , alignment: .center)
    }
}




struct ExploreView_Previews: PreviewProvider {
    static var evm = ExploreViewModel()
    
    static var previews: some View {
        evm.artists = MockData.Artists()
        evm.albums = MockData.Albums()
        evm.songs = MockData.Songs()
        evm.genreOfAlbums = MockData.GenresOfAlbums()
        
        return ExploreView()
            .environmentObject(MainViewModel())
            .environmentObject(evm)
    }
}
