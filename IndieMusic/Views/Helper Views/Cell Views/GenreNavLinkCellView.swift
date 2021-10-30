//
//  ExploreCellView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct GenreNavLinkCellView: View {
    
    let imageName: String?
    let title: String
    let albums: [Album]
    private let imagePlaceholder: UIImage = UIImage.genreImagePlaceholder
    
    var body: some View {
        
        NavigationLink {
            AlbumsView(albums: albums)
        } label: {
            VStack(spacing: 8) {
                if imageName != nil {
                    Image(imageName!)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                } else {
                    Image(uiImage: imagePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                }
                
                Text(title)
                    .foregroundColor(Color.theme.primaryText)
                    .font(.title2)
                    .truncationMode(.tail)
            }
        }
    }
}




struct ExploreCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GenreNavLinkCellView(imageName: "metal", title: "Metal", albums: dev.exploreVM.albums)
                .previewLayout(.sizeThatFits)
            
            GenreNavLinkCellView(imageName: "metal", title: "Metal", albums: dev.exploreVM.albums)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            GenreNavLinkCellView(imageName: "metal", title: "Metal", albums: dev.exploreVM.albums)
                .previewLayout(.sizeThatFits)
            
            GenreNavLinkCellView(imageName: "metal", title: "Metal", albums: dev.exploreVM.albums)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
