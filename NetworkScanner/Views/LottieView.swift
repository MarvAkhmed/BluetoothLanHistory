//
//  LottieView.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let aspectRatio: CGFloat
    
    init(animationName: String, loopMode: LottieLoopMode = .loop, aspectRatio: CGFloat = 1.0) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.aspectRatio = aspectRatio
    }
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.animationSpeed = 1.0
        animationView.shouldRasterizeWhenIdle = true
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}

// MARK: - Blutooth Lottie Container
struct ScanningAnimationView: View {
    var body: some View {
        VStack(spacing: 12) {
            LottieView(animationName: "scanning",
                      loopMode: .loop,
                      aspectRatio: 1.0)
            .background(.clear)
        }
    }
}
