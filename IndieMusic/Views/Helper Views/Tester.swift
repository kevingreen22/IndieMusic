//
//  Tester.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/15/21.
//

import SwiftUI

struct Tester: View {
    let rows1 = [GridItem(.flexible())]
    let rows2 = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        VStack {
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHGrid(rows: rows1) {
//                    ForEach(0..<100) { album in
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color.green)
//                            .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.width / 2.3)
//                    }
//                }.padding(.horizontal)
//            }.frame(maxHeight: 200)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows2) {
                    ForEach(0..<100) { album in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                    }
                }.padding(.horizontal)
            }.frame(maxHeight: 200)
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHGrid(rows: rows1) {
//                    ForEach(0..<100) { album in
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color.blue)
//                            .frame(width: UIScreen.main.bounds.width / 2.3, height: 90)
//                    }
//                }.padding(.horizontal)
//            }.frame(maxHeight: 200)
            
        }
    }
}

struct Tester_Previews: PreviewProvider {
    static var previews: some View {
        Tester()
    }
}
