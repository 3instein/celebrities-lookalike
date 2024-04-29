//
//  ResultView.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 29/04/24.
//

import SwiftUI

struct ResultView: View {
    @Binding var baseImage: UIImage?
    @Binding var result: [[String: String]]?
    
    var body: some View {
        VStack {
            Image(uiImage: baseImage!)
                .resizable()
                .aspectRatio(contentMode: .fill) // Adjust content mode based on whether image is set
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
            VStack {
                HStack {
                    // First row with 3 items
                    if let result = result?.prefix(3) {
                        ForEach(result, id: \.self) { item in
                            AsyncImage(url: URL(string: BASE_URL + "/images/" + item["image_path"]!)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 125, height: 125)
                                    .clipShape(Rectangle())
                                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 125, height: 125)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                HStack {
                    // Second row with 2 items
                    if let result = result?.dropFirst(3) {
                        ForEach(result, id: \.self) { item in
                            AsyncImage(url: URL(string: BASE_URL + "/images/" + item["image_path"]!)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 125, height: 125)
                                    .clipShape(Rectangle())
                                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 125, height: 125)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ResultView(baseImage: .constant(UIImage(named: "Logo")), result: .constant([["": ""]]))
}
