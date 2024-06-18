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
    
    static func loadMonthlyCachedPrayerTimes() -> [String]? {
        let currentMonthKey = formattedDateKeyForMonth(from: Date())
        let nextMonthKey = formattedDateKeyForMonth(from: Calendar.current.date(byAdding: .month, value: 1, to: Date())!)
        let cachedData = UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [String]]
        
        var monthlyData: [String] = []
        
        if let currentMonthData = cachedData?[currentMonthKey] {
            monthlyData.append(contentsOf: currentMonthData)
        }
        
        if let nextMonthData = cachedData?[nextMonthKey] {
            monthlyData.append(contentsOf: nextMonthData.prefix(7))
        }
        
        return monthlyData.isEmpty ? nil : monthlyData
    }
}

