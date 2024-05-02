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
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
            VStack {
                HStack {
                    // First row with 3 items
                    if let result = result?.prefix(3) {
                        ForEach(result, id: \.self) { item in
                            VStack{
                                Text("\(item["distance"] ?? "0")%")
                                AsyncImage(url: URL(string: BASE_URL + "/images/" + item["image_path"]!)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 125, height: 125)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 4))
                                Text("\(item["name"] ?? "")")
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 125, height: 125)
                                        .foregroundColor(.gray)
                                }
                            }.bold()
                        }
                    }
                }
                
                HStack {
                    // Second row with 2 items
                    if let result = result?.dropFirst(3) {
                        ForEach(result, id: \.self) { item in
                            VStack{
                                Text("\(item["distance"] ?? "0")%")
                                AsyncImage(url: URL(string: BASE_URL + "/images/" + item["image_path"]!)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 125, height: 125)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                Text("\(item["name"] ?? "")")
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 125, height: 125)
                                        .foregroundColor(.gray)
                                }
                            }.bold()
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
