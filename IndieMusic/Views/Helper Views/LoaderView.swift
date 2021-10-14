//
//  LoaderView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/14/21.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(2)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .realBlur(style: .light)
                    .cornerRadius(10)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 8)
            )
    }
}



struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            ScrollView {
                Text("Scroll down").font(.largeTitle).bold()
                Text("to see").font(.largeTitle).bold()
                Text("the effect").font(.largeTitle).bold()
                Text("in action.").font(.largeTitle).bold()
            }.offset(y: 160)
            LoaderView()
        }
    }
}
