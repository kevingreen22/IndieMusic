//
//  ExpandableButtonPanel.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/17/21.
//

import SwiftUI


struct ExpandableButtonItem: Identifiable {
    let id = UUID()
    let label: String?
    let imageName: String?
    let action: (() -> Void)?
}



struct ExpandableButtonPanel: View {
    let primaryItem: ExpandableButtonItem
    let secondaryItems: [ExpandableButtonItem]
    let size: CGFloat
    let color: Color
    
    private let noop: () -> Void = {}
    private var cornerRadius: CGFloat {
        get { size / 2 }
    }
    private let shadowColor = Color.black.opacity(0.4)
    private let shadowPosition: (x: CGFloat, y: CGFloat) = (x: 2, y: 2)
    private let shadowRadius: CGFloat = 3

    @Binding var isExpanded: Bool

    var body: some View {
        VStack {
            ForEach(secondaryItems, id: \.id) { item in
                if let label = item.label {
                    Button(label, action: item.action ?? self.noop)
                } else {
                    Button {
                        (item.action ?? self.noop)()
                    } label: {
                        if let name = item.imageName {
                            Image(systemName: name)
                                .foregroundColor(.white)
                        } else if let label = item.label {
                            Text(label)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: self.isExpanded ? self.size : 0,
                           height: self.isExpanded ? self.size : 0)
                }
            }

            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
                self.primaryItem.action?()
            }, label: {
                if let name = primaryItem.imageName {
                    Image(systemName: name)
                        .foregroundColor(.white)
                } else if let label = primaryItem.label {
                    Text(label)
                        .foregroundColor(.white)
                }
            })
            .frame(width: size, height: size)
        }
        .background(color)
        .cornerRadius(cornerRadius)
        .font(.title)
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: shadowPosition.x,
            y: shadowPosition.y
        )
    }
}
    


    



struct ExpandableButtonPanel_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableButtonPanel(primaryItem: ExpandableButtonItem(label: nil, imageName: "plus", action: nil),
                              secondaryItems: [
                                ExpandableButtonItem(label: nil, imageName: "music.note", action: { print("Upload Song pressed") }),
                                ExpandableButtonItem(label: nil, imageName: "rectangle.stack.fill.badge.plus", action: { print("Add album pressed") })
                              ], size: 50, color: .green, isExpanded: .constant(false))
    }
}
