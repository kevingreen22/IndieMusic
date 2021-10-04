//
//  ProgressBarView.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/26/21.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var progress: CGFloat
    let color: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { proxy in
                Capsule()
                    .fill(Color.black.opacity(0.08))
                    .frame(height: 5)
                    .padding(.horizontal)
                
                Capsule()
                    .fill(color)
                    .frame(width: progress / proxy.size.width, height: 5)
                    .padding(.horizontal)
                
                ProgressGlimmer(progress: $progress, height: 5)
                    .padding(.horizontal)
            }
        }
    }
}



fileprivate struct ProgressGlimmer: View {
    @Binding var progress: CGFloat
    let height: CGFloat
    @State private var animateGlimmer = false
    @State private var offset: CGFloat = 0
    
//    private let timer = Timer.publish(every: 0.1, tolerance: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.clear)
                .frame(width: progress, height: height)
                .background(
                    ZStack {
                        if animateGlimmer {
                            HStack {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 12, height: height)
                                    .blur(radius: 2)
                                    .opacity((offset < progress) ? 1 : 0)
                                    .offset(x: offset)
                                
                                Spacer()
                            }
                            .transition(AnyTransition.slide)
                            .animation(.easeInOut(duration: 0.7))
                        }
                    }
                    
                        .frame(width: progress, height: height)
                    
                        .onAppear {
                            animateGlimmer = true
                            withAnimation {
                                offset = progress
                            }
                        }
                    
//                        .onReceive(timer) { time in
//                            if progress < 101 {
//                                offset = progress
//                            } else if progress > 100 {
//                                self.timer.upstream.connect().cancel()
//                            }
//                        }
                )
        }
    }
}




struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                NonObtrusiveNotificationView {
                    ProgressBarView(progress: .constant(50), color: Color.mainApp)
                }
                
                Spacer()
            }
        }
    }
}









struct NonObtrusiveNotificationView<Content: View>: View {
    let content: Content
    let width: CGFloat = 280
    let height: CGFloat = 45
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 4)
            .frame(width: width, height: height, alignment: .center)
            .opacity(0.9)
            .overlay(content)
            .transition(.move(edge: .top))
            .animation(.spring().repeatCount(0, autoreverses: true))

    }
}



