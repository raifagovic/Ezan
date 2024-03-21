//
//  PrayerTimeCalculator.swift
//  AdhanTime
//
//  Created by Raif Agovic on 19. 3. 2024..
//

import Foundation

func timeToNextPrayer(prayerTimes: [String]) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let currentTime = dateFormatter.string(from: Date())
    
    guard let nextPrayerIndex = prayerTimes.firstIndex(where: { $0 > currentTime }),
          nextPrayerIndex < prayerTimes.count else {
        return nil
    }
    let nextPrayerTime = prayerTimes[nextPrayerIndex]
    
    return timeDifference(currentTime: currentTime, nextPrayerTime: nextPrayerTime)
}

func timeDifference(currentTime: String, nextPrayerTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    guard let currentDate = dateFormatter.date(from: currentTime),
          let nextPrayerDate = dateFormatter.date(from: nextPrayerTime) else {
        return "Error"
    }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second], from: currentDate, to: nextPrayerDate)
    
    guard let seconds = components.second else {
        return "Error"
    }
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    let timeToNextPrayer = String(format: "%02d:%02d", max(hours, 0), max(minutes, 0))
    return timeToNextPrayer
}
