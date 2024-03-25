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
    
    let currentTimeString = dateFormatter.string(from: Date())
    print("Current time in Sarajevo: \(currentTimeString)")
    
    guard let currentTimeComponents = currentTimeString.split(separator: ":").map({ Int($0) }),
          let currentHour = currentTimeComponents.first,
          let currentMinute = currentTimeComponents.last else {
        return nil
    }
    
    // Convert current time to minutes
    let currentTimeInMinutes = currentHour * 60 + currentMinute
    
    // Find the next prayer time
    guard let nextPrayerTimeString = prayerTimes.first(where: { $0 > currentTimeString }) else {
        return nil
    }
    
    guard let nextPrayerTimeComponents = nextPrayerTimeString.split(separator: ":").map({ Int($0) }),
          let nextPrayerHour = nextPrayerTimeComponents.first,
          let nextPrayerMinute = nextPrayerTimeComponents.last else {
        return nil
    }
    
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

