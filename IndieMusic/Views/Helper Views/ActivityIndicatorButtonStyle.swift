//
//  ActivityIndicatorButtonStyle.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/12/21.
//

import SwiftUI

struct ActivityIndicatorButtonStyle: ButtonStyle {
    var startActivity: Bool
    let color: Color
    
    init(start: Bool, color: Color = .white) {
        self.startActivity = start
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(startActivity ? 0.4 : 1)
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .opacity(startActivity ? 1 : 0)
            )
    }
}

