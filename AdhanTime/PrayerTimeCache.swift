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
    
    static func loadYearlyCachedPrayerTimes(for year: Int) -> [String]? {
        var yearlyData: [String] = []
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        
        for month in 1...12 {
            let monthKey = formattedDateKeyForMonthAndYear(month: month, year: year)
            if let monthData = cachedData?[monthKey] {
                yearlyData.append(contentsOf: monthData)
                print("Loaded cached prayer times for \(monthKey): \(monthData)")
            } else {
                print("No cached prayer times for \(monthKey)")
            }
        }
        
        return yearlyData.isEmpty ? nil : yearlyData
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
    
    private static func formattedDateKeyForMonthAndYear(month: Int, year: Int) -> String {
        return String(format: "%04d-%02d", year, month)
    }
}

