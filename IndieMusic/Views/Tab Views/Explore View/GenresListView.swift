//
//  GenresListView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/20/21.
//

import SwiftUI

struct GenresListView: View {
    let genres: [String : [Album]]
    
    var body: some View {
        List {
            ForEach(Array(zip(genres.keys, Array(genres.values))), id: \.0) { genre, albums in
                NavigationLink {
                    AlbumsView(albums: albums)
                } label: {
                    ExploreCellView(imageName: nil, title: genre, altText: nil, layoutType: .list)
                }
            }
        }
        .listStyle(PlainListStyle())
        
    }
}

struct GenresListView_Previews: PreviewProvider {
    static var previews: some View {
        //  ["Metal" : [], "Rock" : [], "R&B" : [], "Rap" : [] ]
        GenresListView(genres: dev.genresOfAlbums)
    }
}
