//
//  TimeUtilis.swift
//  AdhanTime
//
//  Created by Raif Agovic on 24. 8. 2024..
//

// TimeUtils.swift

import Foundation

struct TimeUtils {
    static func formatTimeInterval(_ interval: TimeInterval, prayerName: String, isShortFormat: Bool) -> String {
        if interval <= 60 {
            return isShortFormat ? " \(Int(interval)) sec" : "\(prayerName) za \(Int(interval)) sec"
        } else {
            let totalSeconds = Int(interval)
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600 + 59) / 60

            if minutes == 60 {
                return isShortFormat ? " \(hours + 1) h" : "\(prayerName) za \(hours + 1) h"
            }

            if hours > 0 {
                return isShortFormat ? " \(hours) h \(minutes) min" : "\(prayerName) za \(hours) h \(minutes) min"
            } else {
                return isShortFormat ? " \(minutes) min" : "\(prayerName) za \(minutes) min"
            }
        }
    }
}
