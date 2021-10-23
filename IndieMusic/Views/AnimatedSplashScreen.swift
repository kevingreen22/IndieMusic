//
//  AnimatedSplashScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/7/21.
//

import SwiftUI
import FLAnimatedImage

// gif source: https://sentimentsbysingh.com

struct AnimatedSplashScreen: View {
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                GifView(fileName: "record_player")
                    .frame(width: 260, height: 260)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            vm.showSplash = false
                        }
                    }
                
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
