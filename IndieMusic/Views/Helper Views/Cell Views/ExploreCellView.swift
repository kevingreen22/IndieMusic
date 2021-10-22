//
//  ExploreCellView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct ExploreCellView: View {
    
    enum ExploreCellLayoutType {
        case square, list
    }
    
    let imageName: String?
    let title: String
    let altText: String?
    let layoutType: ExploreCellLayoutType
    
    private let imagePlaceholder: UIImage = UIImage.genreImagePlaceholder
    
    init( imageName: String?, title: String, altText: String?, layoutType: ExploreCellLayoutType = .square) {
        self.imageName = imageName
        self.title = title
        self.altText = altText
        self.layoutType = layoutType
    }

    var body: some View {
        switch layoutType {
        case .square:
            VStack(spacing: 8) {
                if imageName != nil {
                 Image(imageName!)
                        .resizable()
                        .scaledToFit()
                }

                Text(title)
                    .foregroundColor(.black)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .truncationMode(.tail)
                
                if altText != nil {
                    Text(altText!)
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .truncationMode(.tail)
                }
            }
            
        case .list:
            HStack {
                if imageName != nil {
                 Image(imageName!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                    
                VStack {
                    Text(title)
                        .foregroundColor(Color.theme.primary)
                        .font((altText != nil) ? .title3 : .title)
                        .fontWeight(.semibold)
                        .truncationMode(.tail)
                    
                    if altText != nil {
                        Text(altText!)
                            .foregroundColor(.gray)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .truncationMode(.tail)
                    }
                }
            }
        }
    }
}




struct ExploreCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil, layoutType: .list)
                .previewLayout(.sizeThatFits)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil, layoutType: .list)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
