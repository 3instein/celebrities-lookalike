//
//  ContentView.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 23/04/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var showCamera: Bool = false
    @State private var image: UIImage?
    @State private var isLoading: Bool = false
    @State private var identificationResult: [[String: String]]?
    
    var body: some View {
        
        if(isLoading){
            LoadingView()
        } else {
            if (identificationResult == nil){
                NavigationView {
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
                            
                            if let image = image {
                                Button(action: {
                                    self.isLoading = true
                                    identify(image: image) { result, error in
                                        if let error = error {
                                            print("Error: \(error.localizedDescription)")
                                            // Handle error
                                        } else if let result = result {
                                            // Handle result
                                            self.identificationResult = result
                                            print(result)
                                            // Set isLoading to false here if needed
                                        }
                                        self.isLoading = false
                                    }
                                }) {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                }
                            }
                        }
                        
                    }.padding()
                }.navigationBarTitle("Identify Celebrities")
            } else {
                ResultView(baseImage: $image, result: $identificationResult)
            }
        }
    }
}

#Preview {
    ContentView()
}
