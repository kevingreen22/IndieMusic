//
//  NotchBackgroundBlur.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/10/21.
//

import SwiftUI

struct TopBlur: View {
    let height: CGFloat
    let radius: CGFloat = 3.0
     
    var body: some View {
        VStack {
            Image("clear")
                .resizable()
                .frame(height: height + radius)
                .blur(radius: radius)
                .offset(y: -radius)
            Spacer()
        }
    }
}

struct TopBlurView: View {
    let height: CGFloat
    let radius: CGFloat = 8.0
     
    var body: some View {
        VStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular))
                .frame(height: height + radius)
                .blur(radius: radius)
                .offset(y: -radius)
            Spacer()
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}


struct NotchBackgroundBlur_Previews: PreviewProvider {
    static var previews: some View {
        TopBlur(height: 35)
//        TopBlurView()
    }
}
