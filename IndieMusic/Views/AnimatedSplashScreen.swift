//
//  AnimatedSplashScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/7/21.
//

import SwiftUI

struct AnimatedSplashScreen: View {
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Indie Music")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .scaleEffect(3)
                    .animation(.easeInOut.repeatForever())
                
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation() {
                        vm.showSplash = false
                    }
                }
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
