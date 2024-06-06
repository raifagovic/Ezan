//
//  TimeUtils.swift
//  AdhanTime
//
//  Created by Raif Agovic on 4. 6. 2024..
//

// TimeUtils.swift

import Foundation

struct TimeUtils {
    static func formatTimeInterval(_ interval: TimeInterval, prayerName: String) -> String {
        if interval <= 60 {
            return "\(prayerName) za \(Int(interval)) sec"
        } else {
            let totalSeconds = Int(interval)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600 + 59) / 60
            
            // Adjust minutes if it equals 60
            if minutes == 60 {
                return "\(prayerName) za \(hours + 1) h"
            }

            if hours > 0 {
                // If hours and minutes are present
                return "\(prayerName) za \(hours) h \(minutes) min"
            } else {
                // Only minutes are present
                return "\(prayerName) za \(minutes) min"
            }
        }
    }
}


