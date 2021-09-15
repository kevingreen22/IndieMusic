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
    
    let colums = [GridItem(.flexible(minimum: ViewModel.Constants.exploreCellSize)), GridItem(.flexible(minimum: ViewModel.Constants.exploreCellSize))]
    
    let rows = [GridItem(.flexible(minimum: ViewModel.Constants.exploreCellSize)), GridItem(.flexible(minimum: ViewModel.Constants.exploreCellSize))]
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                SearchBar(text: $vm.searchText).padding(.vertical)
                
                if !exploreVM.songs.isEmpty {
                    ForEach(exploreVM.songs, id: \.self) { song in
                        Text(song.title)
                    }
                } else {
                    Text("Nothing to Explore")
                        .font(.largeTitle)
                }
                
                
                
                
//                LazyHGrid(rows: rows) {
//                    ForEach(exploreVM.genreCells, id: \.self) { cell in
//                        NavigationLink(
//                            destination: ArtistsView(artists: exploreVM.genreOfArtists[cell.genre]!)
//                                .environmentObject(vm),
//                            label: {
//                                ExploreViewCell(content: cell)
//                                    .environmentObject(vm)
//                            })
//                    }
//                }
                
                

            }
        }
        
        .onAppear {
            exploreVM.getSongs()
        }
        
    }
}












struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(ViewModel())
            .environmentObject(ExploreViewModel())
    }
}
