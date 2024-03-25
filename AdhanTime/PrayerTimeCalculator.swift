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
    dateFormatter.timeZone = TimeZone(identifier: "Europe/Sarajevo") // Set the time zone
    
    let currentTime = Date()
    print("Current time in Sarajevo: \(dateFormatter.string(from: currentTime))")
    
    // Convert prayer times to Date objects
    let prayerDateTimes = prayerTimes.compactMap { dateFormatter.date(from: $0) }
    
    // Find the next prayer time
    guard let nextPrayerDateTime = prayerDateTimes.first(where: { $0 > currentTime }) else {
        return nil
    }
    
    // Calculate time difference
    let timeDifference = Int(nextPrayerDateTime.timeIntervalSince(currentTime))
    let hours = timeDifference / 3600
    let minutes = (timeDifference % 3600) / 60
    
    return "\(hours)h \(minutes)min"
}


    
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: nextPrayerDate)
//    
//    guard let hours = components.hour, let minutes = components.minute else {
//        return "Error"
//    }
//    
//    if hours == 0 && minutes == 0 {
//        return "Less than a minute"
//    }
//    
//    if hours == 0 {
//        return "\(minutes)min"
//    }
//    
//    if minutes == 0 {
//        return "\(hours)h"
//    }
//    
//    return "\(hours)h \(minutes)min"

