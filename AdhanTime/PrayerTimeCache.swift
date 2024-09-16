//
//  PrayerTimeCache.swift
//  AdhanTime
//
//  Created by Raif Agovic on 25. 8. 2024..
//

import Foundation

class PrayerTimeCache {
    static let cacheKey = "cachedPrayerTimes"
    
    static func savePrayerTimes(_ prayerTimes: [String], for date: Date, locationId: Int) {
        let dateKey = formattedDateKey(from: date, locationId: locationId)
        var cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]] ?? [:]
        cachedData[dateKey] = prayerTimes
        UserDefaults.standard.set(cachedData, forKey: cacheKey)
        print("Saved prayer times for \(dateKey): \(prayerTimes)")
    }
    
    static func loadCachedPrayerTimes(for date: Date, locationId: Int) -> [String]? {
        let dateKey = formattedDateKey(from: date, locationId: locationId)
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        let data = cachedData?[dateKey]
        print("Loaded cached prayer times for \(dateKey): \(data ?? [])")
        return data
    }
 
    
    static func removeOldData(before date: Date) {
        let dateKey = formattedDateKey(from: date, locationId: nil) // No need for locationId here
        var cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]] ?? [:]
        cachedData = cachedData.filter { $0.key >= dateKey }
        UserDefaults.standard.set(cachedData, forKey: cacheKey)
        print("Removed old data before \(dateKey)")
    }
    
    private static func formattedDateKey(from date: Date, locationId: Int?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateKey = formatter.string(from: date)
        if let locationId = locationId {
            dateKey += "-\(locationId)"
        }
        return dateKey
    }
}

