//
//  API.swift
//  celebrities-lookalike
//
//  Created by Reynaldi Kindarto on 29/04/24.
//

import SwiftUI

let BASE_URL = "https://bc1e-139-228-45-215.ngrok-free.app/"

func identify(image: UIImage, completion: @escaping ([[String: String]]?, Error?) -> Void) {
    // Prepare the request
    
    let identifyURL = URL(string: (BASE_URL + "identify"))
    
    var request = URLRequest(url: identifyURL!)
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
        completion(nil, NSError(domain: "com.yourapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
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
            completion(nil, error)
            return
        }

        // Print the response
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                do {
                    // Parse JSON data
                    if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        // Map JSON to an array of dictionaries containing name, image path, and distance
                        let result = json.map { dictionary -> [String: String] in
                            return [
                                "name": dictionary["name"] as? String ?? "",
                                "image_path": dictionary["image_path"] as? String ?? "",
                                "distance": "\(dictionary["distance"] ?? "")"
                            ]
                        }
                        // Return the result
                        completion(result, nil)
                    } else {
                        completion(nil, NSError(domain: "com.yourapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                    }
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, NSError(domain: "com.yourapp", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }

    task.resume()
}


