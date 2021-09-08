//
//  GenericViews.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/19/21.
//

import SwiftUI

struct GenericListCell: View {
    let imageName: String
    let label: String
    let typeOfFavorite: AnyClass?
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30
    @State private var isFavorited: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .aspectRatio(contentMode: .fit)
            Text(label)
            Spacer()
            if typeOfFavorite != nil {
                FarvoriteStarView(typeOfFavorite: typeOfFavorite, isFavorited: $isFavorited)
            }
        }
    }
}



struct FarvoriteStarView: View {
    let typeOfFavorite: AnyClass?
    @Binding var isFavorited: Bool
    
    var body: some View {
        Button(action: {
            // favorite artist/album/song in model here
            
        }, label: {
            Image(systemName: isFavorited ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }).highPriorityGesture(
            TapGesture().onEnded({ () in
                isFavorited.toggle()
            })
        )
    }
}











struct GenericViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GenericListCell(imageName: "dillinger",
                            label: "Dillinger",
                            typeOfFavorite: nil)
            FarvoriteStarView(typeOfFavorite: Artist.self, isFavorited: .constant(false))
        }
    }
}
