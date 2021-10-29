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
    
    init(imageName: String?, title: String, altText: String?, layoutType: ExploreCellLayoutType = .square) {
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
                        .padding(4)
                }

                Text(title)
                    .foregroundColor(Color.theme.primaryText)
                    .font(.title)
                    .fontWeight(.semibold)
                    .truncationMode(.tail)
                
                if altText != nil {
                    Text(altText!)
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .truncationMode(.tail)
                        .padding(.bottom, 5)
                }
            }
            
        case .list:
            HStack {
                if imageName != nil {
                 Image(imageName!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(5)
                }
                    
                VStack {
                    Text(title)
                        .foregroundColor(Color.theme.primaryText)
                        .font((altText != nil) ? .title3 : .title)
                        .fontWeight(.semibold)
                        .truncationMode(.tail)
                        .padding(.trailing, 5)
                    
                    if altText != nil {
                        Text(altText!)
                            .foregroundColor(Color.theme.secondaryText)
                            .font(.body)
                            .fontWeight(.semibold)
                            .truncationMode(.tail)
                            .padding(.trailing, 5)
                    }
                }
            }
        }
    }
}




struct ExploreCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExploreCellView(imageName: "metal", title: "Metal", altText: "Heavy Metal", layoutType: .square)
                .previewLayout(.sizeThatFits)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: "Heavy Metal", layoutType: .square)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: "Heavy Metal", layoutType: .list)
                .previewLayout(.sizeThatFits)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: "Heavy Metal", layoutType: .list)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
