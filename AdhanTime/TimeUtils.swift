//
//  TimeUtils.swift
//  AdhanTime
//
//  Created by Raif Agovic on 4. 6. 2024..
//

import Foundation

struct TimeUtils {
    static func formatTimeInterval(_ interval: TimeInterval, prayerName: String) -> String {
        if interval <= 60 {
            return "\(prayerName) za \(Int(interval)) sec"
        } else {
            let hours = Int(interval) / 3600
            let minutes = (Int(interval) % 3600 + 59) / 60
            if hours > 0 {
                return "\(prayerName) za \(hours) h \(minutes) min"
            } else {
                return "\(prayerName) za \(minutes) min"
            }
        }
    }
}

