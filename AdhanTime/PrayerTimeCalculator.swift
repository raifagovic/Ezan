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
    
    // Identify the current prayer and its index
    guard let currentPrayerIndex = prayerTimes.firstIndex(where: { $0 > currentTime }),
          currentPrayerIndex < prayerTimes.count else {
        return nil // If no prayer times remain for the day, return nil
    }
    
    // Retrieve the current prayer time
    let currentPrayerTime = prayerTimes[currentPrayerIndex]
    
    // Handle special case for Fajr (accounting for Sunrise end time)
    if currentPrayerIndex == 0 && prayerTimes.count > 1 {
        let sunriseEndTime = prayerTimes[1] // Second value in the array is considered as the end time of Fajr
        // Check if it's past the end of Fajr (Sunrise)
        if currentTime > sunriseEndTime {
            // If past Sunrise, move to the next prayer (Dhuhr)
            return timeDifference(currentTime: currentTime, nextPrayerTime: prayerTimes[2])
        }
    }
    
    // Calculate time to the next prayer
    return timeDifference(currentTime: currentTime, nextPrayerTime: currentPrayerTime)
}

func timeDifference(currentTime: String, nextPrayerTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    guard let currentDate = dateFormatter.date(from: currentTime),
          let nextPrayerDate = dateFormatter.date(from: nextPrayerTime) else {
        return "Error" // Return an error message if date conversion fails
    }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: currentDate, to: nextPrayerDate)
    guard let hours = components.hour, let minutes = components.minute else {
        return "Error" // Return an error message if components are nil
    }
    
    let timeToNextPrayer = String(format: "%02d:%02d", max(hours, 0), max(minutes, 0))
    return timeToNextPrayer
}
