//
//  AlbumsView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject var vm: MainViewModel
    var albums: [Album]
    var direction: Axis.Set = .vertical
    
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        ScrollView(direction) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(albums, id: \.self ) { album in
                    AlbumNavLinkCellView(album: album)
                        .environmentObject(vm)
                }
            }.padding()
        }
        
        .navigationBarTitle("Albums", displayMode: .large)
    }
}








struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: dev.albums)
            .environmentObject(dev.mainVM)
    }
}
