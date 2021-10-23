//
//  AnimatedSplashScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/7/21.
//

import SwiftUI
import FLAnimatedImage

// Record player icon is from "https://www.flaticon.com/authors/surang"

struct AnimatedSplashScreen: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var startAnimation = false
    
    var body: some View {
        ZStack {
            Color.theme.primary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                GifView(fileName: "record_player")
                
                Spacer()
            }
            
        }
    }
}





struct AnimatedSplashScreen_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AnimatedSplashScreen()

            AnimatedSplashScreen()
                .preferredColorScheme(.dark)
        }
    }
}
