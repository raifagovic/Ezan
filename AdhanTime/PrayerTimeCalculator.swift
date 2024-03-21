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

// Function to calculate time difference between two time strings
func timeDifference(currentTime: String, nextPrayerTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    // Convert the current time and next prayer time strings to Date objects
    guard let currentDate = dateFormatter.date(from: currentTime),
          let nextPrayerDate = dateFormatter.date(from: nextPrayerTime) else {
        return "Error" // Return an error message if date conversion fails
    }
    
    // Calculate the time difference in seconds between the current time and the next prayer time
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second], from: currentDate, to: nextPrayerDate)
    
    // Extract seconds from the components
    guard let seconds = components.second else {
        return "Error" // Return an error message if components are nil
    }
    
    // Calculate hours and minutes from the time difference in seconds
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    // Format the time difference as a string
    let timeToNextPrayer = String(format: "%02d:%02d", max(hours, 0), max(minutes, 0))
    return timeToNextPrayer
}
