//
//  PrayerTimeCache.swift
//  AdhanTime
//
//  Created by Raif Agovic on 13. 6. 2024..
//

import Foundation

class PrayerTimeCache {
    static let cacheKey = "cachedPrayerTimes"
    
    static func savePrayerTimes(_ prayerTimes: [String], for date: Date) {
        let dateKey = formattedDateKey(from: date)
        var cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]] ?? [:]
        cachedData[dateKey] = prayerTimes
        UserDefaults.standard.set(cachedData, forKey: cacheKey)
        print("Saved prayer times for \(dateKey): \(prayerTimes)")
    }
    
    static func loadCachedPrayerTimes(for date: Date) -> [String]? {
        let dateKey = formattedDateKey(from: date)
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        let data = cachedData?[dateKey]
        print("Loaded cached prayer times for \(dateKey): \(data ?? [])")
        return data
    }
    
    static func removeOldData(before date: Date) {
        let dateKey = formattedDateKey(from: date)
        var cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]] ?? [:]
        cachedData = cachedData.filter { $0.key >= dateKey }
        UserDefaults.standard.set(cachedData, forKey: cacheKey)
        print("Removed old data before \(dateKey)")
    }
    
    private static func formattedDateKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

