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
    
    let currentTime = dateFormatter.string(from: Date())
    print("Current time in Sarajevo: \(currentTime)")
    
    guard let nextPrayerIndex = prayerTimes.firstIndex(where: { $0 > currentTime }),
          nextPrayerIndex < prayerTimes.count else {
        return nil
    }
    let nextPrayerTime = prayerTimes[nextPrayerIndex]
    
    return timeDifference(currentTime: currentTime, nextPrayerTime: nextPrayerTime)
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

