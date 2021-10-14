//
//  RealBlurView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/14/21.
//

import SwiftUI
import UIKit


/// This SwiftUI blur view mimics the original UIKit version of UIBlurEffect. It allows to have more controll of where the blur is actually bluring. Similar to iOS 14's .material modifier.
/// This blur view can be used as a stand alone View, or as a modifier to any view.
/// An Example is provided within this file.
struct RealBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .regular) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: effect)
        return effectView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    
}


extension View {
    
    func realBlur(style: UIBlurEffect.Style = .regular) -> some View {
        RealBlurView(style: style)
    }
    
}




// EXAMPLE
struct Example: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .realBlur(style: .light)
            .cornerRadius(10)
            .frame(width: 100, height: 100)
            .shadow(radius: 8)
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            ScrollView {
                Text("Scroll down").font(.largeTitle).bold()
                Text("to see").font(.largeTitle).bold()
                Text("the effect").font(.largeTitle).bold()
                Text("in action.").font(.largeTitle).bold()
            }.offset(y: 160)
            Example()
        }
    }
}
