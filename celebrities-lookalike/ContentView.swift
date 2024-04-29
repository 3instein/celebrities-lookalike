//
//  ContentView.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 23/04/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var showCamera = false
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage(named: "Logo")!)
                .resizable()
                .aspectRatio(contentMode: image != nil ? .fill : .fit) // Adjust content mode based on whether image is set
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2))

            HStack {
                Spacer().frame(width: image != nil ? 75 : 0)
                
                Button(action: {
                    ImagePicker.checkPermissionsAndOpenCamera(showCamera: showCamera) { success in
                        if success {
                            self.showCamera = true
                        }
                    }
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                }.sheet(isPresented: $showCamera) {
                    ImagePicker(image: self.$image, showCamera: self.$showCamera)
                }
                
                if(image != nil) {
                    Button(action: {
                        identify(image: (image ?? UIImage(systemName: "logo"))!)
                    }) {
                        Image(systemName: "arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    }
                }
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
