//
//  PrayerTimeCalculator.swift
//  AdhanTime
//
//  Created by Raif Agovic on 19. 3. 2024..
//

import Foundation


// Function to calculate time difference between two time strings
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
    
    // Calculate time to the next prayer
    return timeDifference(currentTime: currentTime, nextPrayerTime: currentPrayerTime)
}

// Function to calculate time difference between two time strings
func timeDifference(currentTime: String, nextPrayerTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    guard let currentDate = dateFormatter.date(from: currentTime),
          let nextPrayerDate = dateFormatter.date(from: nextPrayerTime) else {
        return "Error"
    }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: currentDate, to: nextPrayerDate)
    guard let hours = components.hour, let minutes = components.minute else {
        return "Error" 
    }
    
    let timeToNextPrayer = String(format: "%02d:%02d", max(hours, 0), max(minutes, 0))
    return timeToNextPrayer
}
