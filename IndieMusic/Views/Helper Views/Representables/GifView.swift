//
//  GifView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/22/21.
//

import Foundation
import SwiftUI
import FLAnimatedImage

struct GifView: UIViewRepresentable {
    let animatedView = FLAnimatedImageView()
    var fileName: String
    
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "gif") else { return view }
        let url = URL(fileURLWithPath: path)
        let gifData = try? Data(contentsOf: url)
        
        let gif = FLAnimatedImage(animatedGIFData: gifData)
        animatedView.animatedImage = gif
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animatedView)
        
        NSLayoutConstraint.activate([
            animatedView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animatedView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    
}
