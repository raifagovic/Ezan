//
//  PrayerTimeAPI.swift
//  AdhanTime
//
//  Created by Raif Agovic on 29. 4. 2024..
//

import Foundation

struct PrayerTimeAPI {
    static let baseURL = "https://api.vaktija.ba/vaktija/v1"
    
    static func fetchPrayerTimes(for locationId: Int, year: Int, month: Int, day: Int, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "\(baseURL)/\(locationId)/\(year)/\(month)/\(day)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let prayerTimes = try parsePrayerTimes(data: data)
                completion(.success(prayerTimes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func parsePrayerTimes(data: Data) throws -> [String] {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let response = try decoder.decode(PrayerTimeResponse.self, from: data)
        
        // Convert date strings to formatted time strings
        let prayerTimes = response.vakat.map { $0 }
        return prayerTimes
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct PrayerTimeResponse: Decodable {
    let vakat: [String]
}
