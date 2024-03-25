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
    dateFormatter.timeZone = TimeZone(identifier: "Europe/Sarajevo") 
    
    let currentTimeString = dateFormatter.string(from: Date())
    print("Current time in Sarajevo: \(currentTimeString)")
    
    let currentTimeComponents = currentTimeString.split(separator: ":").compactMap { Int($0) }
    guard currentTimeComponents.count == 2 else {
        return nil
    }
    
    let currentHour = currentTimeComponents[0]
    let currentMinute = currentTimeComponents[1]
    
    // Convert current time to minutes
    let currentTimeInMinutes = currentHour * 60 + currentMinute
    
    // Find the next prayer time
    guard let nextPrayerTimeString = prayerTimes.first(where: { $0 > currentTimeString }) else {
        return nil
    }
    
    let nextPrayerTimeComponents = nextPrayerTimeString.split(separator: ":").compactMap { Int($0) }
    guard nextPrayerTimeComponents.count == 2 else {
        return nil
    }
    
    let nextPrayerHour = nextPrayerTimeComponents[0]
    let nextPrayerMinute = nextPrayerTimeComponents[1]
    
    // Convert next prayer time to minutes
    let nextPrayerTimeInMinutes = nextPrayerHour * 60 + nextPrayerMinute
    
    // Calculate time difference in minutes
    var timeDifferenceInMinutes = nextPrayerTimeInMinutes - currentTimeInMinutes
    
    // Adjust for negative time difference (next prayer time is on the next day)
    if timeDifferenceInMinutes < 0 {
        timeDifferenceInMinutes += 1440 // 24 hours in minutes
    }
    
    let hours = timeDifferenceInMinutes / 60
    let minutes = timeDifferenceInMinutes % 60
    
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

