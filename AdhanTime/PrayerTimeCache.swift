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
    }
    
    static func loadCachedPrayerTimes(for date: Date) -> [String]? {
        let dateKey = formattedDateKey(from: date)
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        return cachedData?[dateKey]
    }
    
    static func loadYearlyCachedPrayerTimes(for year: Int) -> [String]? {
        var yearlyData: [String] = []
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        
        for month in 1...12 {
            let dateKey = formattedDateKeyForMonthAndYear(month: month, year: year)
            if let monthlyData = cachedData?[dateKey] {
                yearlyData.append(contentsOf: monthlyData)
            }
        }
        
        return yearlyData.isEmpty ? nil : yearlyData
    }
    
    static func removeOldData(before date: Date) {
        let dateKey = formattedDateKey(from: date)
        var cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]] ?? [:]
        cachedData = cachedData.filter { $0.key >= dateKey }
        UserDefaults.standard.set(cachedData, forKey: cacheKey)
    }
    
    private static func formattedDateKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

