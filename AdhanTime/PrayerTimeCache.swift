//
//  PrayerTimeCache.swift
//  AdhanTime
//
//  Created by Raif Agovic on 13. 6. 2024..
//

import Foundation

class PrayerTimeCache {
    static let cacheKey = "cachedPrayerTimes"
    
    static func savePrayerTimes(_ prayerTimes: [String]) {
        UserDefaults.standard.set(prayerTimes, forKey: cacheKey)
    }
    
    static func loadCachedPrayerTimes() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: cacheKey)
    }
}

