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
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .opacity(0.7)
                    
            )
    }
    
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            VStack {
                LoaderView()
            }
        }
    }
}
