//
//  VolumeSliderView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/21/21.
//

import SwiftUI
import UIKit
import MediaPlayer

struct VolumeSliderView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volume = MPVolumeView(frame: .zero)
        volume.showsRouteButton = false
        return volume
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}



struct VolumeSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            VolumeSliderView()
        }
    }
}
