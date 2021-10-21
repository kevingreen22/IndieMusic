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
//                if #available(iOS 15, *) {
//                    Text(vm.searchText)
//                        .searchable(text: $exploreVM.searchText, prompt: "Search and explore!")
//                } else {
                    SearchBar(text: $exploreVM.searchText)
//                }
                
                
                // ARTISTS
//                GridWithTitleAndSeeAll(
//                    title: "Artists",
//                    destination:
//                        ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm),
//                    grid: artistGridView
//                )
                artistGridView
                
                Divider()
                
                //ALBUMS
//                GridWithTitleAndSeeAll(
//                    title: "Albums",
//                    destination:
//                        AlbumsView(albums: exploreVM.albums.sorted()).environmentObject(vm),
//                    grid: albumsGridView
//                )
                albumsGridView
                
                
                Divider()
                
                //GENRES
//                GridWithTitleAndSeeAll(
//                    title: "Genres",
//                    destination: AlbumsView(albums: exploreVM.albumsForGenre).environmentObject(vm),
//                    grid: genreGridView
//                ).onPreferenceChange(GenreOfAlbumsIndexPreferenceKey.self) { albums in
//                    exploreVM.albumsForGenre = albums
//                }
                genreGridView
                
                
                
                
                Divider()
                
                // SONGS
//                GridWithTitleAndSeeAll(
//                    title: "Songs",
//                    destination: EmptyView(),
//                    isActive: false,
//                    grid: songListView
//                )
                songListView
                
                
            }
        }
    }
}



extension ExploreView {
    
//    func GridWithTitleAndSeeAll<Dest: View, Grid: View>(title: String, destination: Dest, isActive: Bool = true, grid: Grid) -> some View {
//        VStack {
//            HStack {
//                Text(title)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.leading)
//                Spacer()
//
//                NavigationLink(isActive: .constant(isActive)) {
//                    destination
//                } label: {
//                    Text("See All")
//                        .foregroundColor(.mainApp)
//                        .padding(.trailing)
//                }
//            }.padding(.bottom)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                grid.padding(.horizontal)
//            }.frame(maxHeight: 200)
//        }
//    }
    
//    func headerWithSeeAllButton(title: String) -> some View {
//        HStack {
//            Text(title)
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.leading)
//            Spacer()
//            NavigationLink {
//                AlbumsView(albums: exploreVM.albums.sorted()).environmentObject(vm)
//            } label: {
//                Text("See All")
//                    .foregroundColor(.mainApp)
//                    .padding(.trailing)
//            }
//        }.padding(.bottom)
//    }
    
    var artistGridView: some View {
        let rows = [GridItem(.flexible()),
                     GridItem(.flexible()),
                     GridItem(.flexible())
        ]
        return VStack {
            HStack {
                Text("Artists")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    ArtistsView(artists: exploreVM.artists.sorted()).environmentObject(vm)
                } label: {
                    Text("See All")
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
            }.padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(exploreVM.artists.sorted(), id: \.self) { artist in
                        ArtistNavLinkCell(artist: artist)
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: 50)
                            .environmentObject(vm)
                    }
                }//.padding(.horizontal)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
        }
    }
    
    var albumsGridView: some View {
        let rows = [GridItem(.flexible())]
        
        return VStack {
            HStack {
                Text("Albums")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                NavigationLink {
                    AlbumsView(albums: exploreVM.albums.sorted()).environmentObject(vm)
                } label: {
                    Text("See All")
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
            }.padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(exploreVM.albums.prefix(10).sorted(), id: \.self) { album in
                        AlbumNavLinkCellView(album: album)
                            .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.width / 2.3)
                            .environmentObject(vm)
                    }
                }//.padding(.horizontal)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
        }
    }
    
    var genreGridView: some View {
        let rows = [GridItem(.flexible())]
        return VStack {
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
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
            }.padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(Array(zip(exploreVM.genreOfAlbums.keys, Array(exploreVM.genreOfAlbums.values))), id: \.0) { genre, albums in
                        ExploreCellView(imageName: nil, title: genre, altText: nil)
                            .frame(width: UIScreen.main.bounds.width / 2.3, height: 90)
                            .environmentObject(vm)
                            .preference(key: GenreOfAlbumsIndexPreferenceKey.self, value: albums)
                    }
                }//.padding(.horizontal)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
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
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
            }.padding(.bottom)
            
            List {
                ForEach(exploreVM.songs, id: \.self) { song in
                    SongListCell(song: song, selectedSongCell: .constant(nil))
                }
            }.listStyle(DefaultListStyle())
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
        ExploreView()
            .environmentObject(dev.mainVM)
            .environmentObject(dev.exploreVM)
    }
}
