//
//  PrayerTimeAPI.swift
//  AdhanTime
//
//  Created by Raif Agovic on 29. 4. 2024..
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct PrayerTimeResponse: Decodable {
    let vakat: [String]?
    let mjesec: [DayPrayerTime]?
    
    struct DayPrayerTime: Decodable {
        let vakat: [String]
    }
    
    enum CodingKeys: String, CodingKey {
        case vakat
        case mjesec
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vakat = try container.decodeIfPresent([String].self, forKey: .vakat)
        
        // Decode `mjesec` as an array of DayPrayerTime if present
        if let monthData = try? container.decode([DayPrayerTime].self, forKey: .mjesec) {
            self.mjesec = monthData
        } else {
            self.mjesec = nil
        }
    }
}

struct PrayerTimeAPI {
    static let baseURL = "https://api.vaktija.ba/vaktija/v1"
    
    static func fetchPrayerTimes(for locationId: Int, year: Int, month: Int, day: Int? = nil, completion: @escaping (Result<[String], Error>) -> Void) {
        var urlString = "\(baseURL)/\(locationId)/\(year)/\(month)"
        if let day = day {
            urlString += "/\(day)"
        }
        
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
            
            // Debug: Print raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(jsonString)")
            } else {
                print("Failed to convert response data to string.")
            }
            
            do {
                let prayerTimes = try parsePrayerTimes(data: data, forDay: day != nil)
                
                // Debug: Print parsed prayer times
                print("Parsed prayer times: \(prayerTimes)")
                
                completion(.success(prayerTimes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func parsePrayerTimes(data: Data, forDay: Bool) throws -> [String] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(PrayerTimeResponse.self, from: data)
        
        // Debug: Print the decoded response
        print("Decoded PrayerTimeResponse: \(response)")
        
        if forDay, let prayerTimes = response.vakat {
            return prayerTimes
        } else if let monthlyPrayerTimes = response.mjesec {
            return monthlyPrayerTimes.flatMap { $0.vakat }
        }
        
        throw NetworkError.invalidData
    }
}


