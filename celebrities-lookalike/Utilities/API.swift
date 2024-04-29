//
//  API.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 29/04/24.
//

import SwiftUI

let BASE_URL = URL(string:"https://bc1e-139-228-45-215.ngrok-free.app/identify")

func identify(image: UIImage) {
    // Prepare the request
    var request = URLRequest(url: BASE_URL!)
    request.httpMethod = "POST"

    // Create a boundary for the multipart form-data
    let boundary = "Boundary-\(UUID().uuidString)"

    // Prepare the body of the request
    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"base_image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

    // Convert UIImage to JPEG data
    if let imageData = image.jpegData(compressionQuality: 0.8) {
        body.append(imageData)
    } else {
        print("Failed to convert image to data")
        return
    }

    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    // Set the content type and length
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

    // Attach the body to the request
    request.httpBody = body

    // Perform the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        // Print the response
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Invalid JSON response")
                }
            } else {
                print("Error response: \(httpResponse.statusCode)")
            }
        }
    }

    task.resume()
}

