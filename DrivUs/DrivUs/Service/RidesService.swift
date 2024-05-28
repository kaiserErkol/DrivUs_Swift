//
//  RidesService.swift
//  DrivUs
//
//  Created by MacBook on 30.04.24.
//

import Foundation

class RidesService {
    static let shared = RidesService()
    
    func fetchRides(completion: @escaping ([RideObject]?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/rides") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Specify GET method
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let loadedRides = try JSONDecoder().decode([RideObject].self, from: data)
                completion(loadedRides)
            } catch {
                print("Error decoding posts: \(error)")
                completion(nil)
            }
        }.resume()
    }
}


