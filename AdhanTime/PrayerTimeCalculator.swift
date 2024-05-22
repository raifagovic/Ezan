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
    
    let currentTimeComponents = currentTimeString.split(separator: ":").compactMap { Int($0) }
    guard currentTimeComponents.count == 2 else {
        return nil
    }
    
    let currentHour = currentTimeComponents[0]
    let currentMinute = currentTimeComponents[1]
    
    // Convert current time to minutes
    let currentTimeInMinutes = currentHour * 60 + currentMinute
    
    // Find the next prayer time
    guard let nextPrayerTimeString = prayerTimes.first(where: {
        let components = $0.split(separator: ":")
        guard components.count == 2, let hour = Int(components[0]), let minute = Int(components[1]) else {
            return false
        }
        let prayerTimeInMinutes = hour * 60 + minute
        return prayerTimeInMinutes > currentTimeInMinutes
    }) else {
        return nil
    }
    
    // Determine the index of the next prayer time
    guard let index = prayerTimes.firstIndex(of: nextPrayerTimeString) else {
        return nil
    }
    
    // Define the array of prayer names
    let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]
    
    // Determine the name of the next prayer
    guard index < prayerNames.count else {
        return nil
    }
    
    let nextPrayerName = prayerNames[index]
    
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
    
    let totalSeconds = timeDifferenceInMinutes * 60
    let currentTimeInSeconds = currentTimeInMinutes * 60 + Calendar.current.component(.second, from: Date())
    let nextPrayerTimeInSeconds = nextPrayerTimeInMinutes * 60
    var timeDifferenceInSeconds = nextPrayerTimeInSeconds - currentTimeInSeconds
    
    let hours = timeDifferenceInMinutes / 60
    let minutes = timeDifferenceInMinutes % 60
    
    if hours == 0 {
            return "\(nextPrayerName) je za \(minutes)min"
        } else {
            return "\(nextPrayerName) je za \(hours)h \(minutes)min"
        }
}


