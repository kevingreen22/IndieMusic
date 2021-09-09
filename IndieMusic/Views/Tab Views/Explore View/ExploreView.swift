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
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                SearchBar(text: $vm.searchText).padding(.vertical)
                
                LazyVGrid(columns: colums) {
                    ForEach(exploreVM.exploreCells, id: \.self) { cell in
                        NavigationLink(
                            destination: ArtistsView(artists: exploreVM.genreOfArtists[cell.genre]!),
                            label: {
                                ExploreViewCell(content: cell) 
                                    .environmentObject(vm)
                            })
                    }
                }
            }
        }
        
        .onAppear {
            exploreVM.getAllGenres()
        }
        
    }
}


struct ExploreViewCell: View {
    @EnvironmentObject var vm: ViewModel
    let content: ExploreCellModel
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .overlay(
                Image(content.imageName ?? "genre_image_placeholder")
                    .resizable()
            )
            .cornerRadius(25)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    Text(content.genre)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .lineLimit(2)
                        .padding(.bottom)
                }
            )
            .frame(height: ViewModel.Constants.exploreCellSize)
            .padding(.horizontal)
    }
}











struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .environmentObject(ViewModel())
    }
}
