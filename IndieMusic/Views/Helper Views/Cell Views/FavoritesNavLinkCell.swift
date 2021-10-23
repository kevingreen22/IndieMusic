//
//  FavoritesNavLinkCell.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct FavoritesNavLinkCell: View {
    @State private var isFavorited: Bool = false
    let systemImageName: String
    let label: String
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30

    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(3)
                .foregroundColor(Color.theme.primary)
            Text(label)
                .fontWeight(.semibold)
        }
    }
}




struct FavoritesNavLinkCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoritesNavLinkCell(systemImageName: "photo", label: "Favorites Cell")
                .previewLayout(.sizeThatFits)
            
            FavoritesNavLinkCell(systemImageName: "photo", label: "Favorites Cell")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
