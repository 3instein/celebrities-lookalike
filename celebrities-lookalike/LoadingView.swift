//
//  LoadingView.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 29/04/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            ZStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Adjust content mode based on whether image is set
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 4))
                    .rotationEffect(.degrees(rotation))
                    .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
                    .onAppear {
                        self.rotation = 360
                    }
            }
            Text("Analyzing...")
                .font(.custom("Kavoon-Regular", size: 36))
                .padding()
        }
    }
}
