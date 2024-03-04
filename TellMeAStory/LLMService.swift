//
//  LLMService.swift
//  TellMeAStory
//
//  Created by Tony Jiang on 3/3/24.
//

import Foundation

class LLMService {
    let createStoryUrl = URL(string: "http://localhost:8000/createStory")!
    let createImageUrl = URL(string: "http://localhost:8000/createImage")!
    let session = URLSession.shared
    struct RequestBody: Codable {
        let items: [String]
    }
    struct ResponseBody: Codable {
        let story: [String]
    }
    
    struct ImageRequestBody: Codable {
        let string: String
    }
    struct ImageResponseBody: Codable {
        let image_url: String
    }
    
    func fetchData(strings: [String], completion: @escaping ([String]?) -> Void) {
        // Create the request body
        let requestBody = RequestBody(items: strings)
        
        // Create JSON data from the request body
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(nil)
            return
        }
        // Create a URLRequest
        var request = URLRequest(url: createStoryUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create a URLSession object
        let session = URLSession.shared
        // Create a URLSession data task
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            // Check for successful response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            // Check if data is available
            guard let responseData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Decode JSON response data
            do {
                let responseBody = try JSONDecoder().decode(ResponseBody.self, from: responseData)
                completion(responseBody.story)
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
        
        // Resume the task to start the request
        task.resume()
    }
    func fetchImage(string: String, completion: @escaping (String?) -> Void) {
        let requestBody = ImageRequestBody(string: string)
        
        // Create JSON data from the request body
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(nil)
            return
        }
        // Create a URLRequest
        var request = URLRequest(url: createImageUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create a URLSession object
        let session = URLSession.shared
        // Create a URLSession data task
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            // Check for successful response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            // Check if data is available
            guard let responseData = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Decode JSON response data
            do {
                let responseBody = try JSONDecoder().decode(ImageResponseBody.self, from: responseData)
                completion(responseBody.image_url)
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
        
        // Resume the task to start the request
        task.resume()
    }
}
