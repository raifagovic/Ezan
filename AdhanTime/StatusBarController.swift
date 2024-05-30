//
//  StatusBarController.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 5. 2024..
//

import Cocoa

class StatusBarController {
    private var statusItem: NSStatusItem
    private var timer: Timer?

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "Loading..."
        }
        
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar), userInfo: nil, repeats: true)
    }

    @objc func updateStatusBar() {
        // Call the function to fetch and format the remaining time
        if let (remainingTime, nextPrayerName) = fetchRemainingTime() {
            let timeString = formatTimeInterval(remainingTime, prayerName: nextPrayerName)
            statusItem.button?.title = timeString
        }
    }

    func fetchRemainingTime() -> (TimeInterval, String)? {
        // Your logic to fetch the remaining time and next prayer name
        // For simplicity, you can use the timeToNextPrayer function
        let prayerTimes = ["03:30", "05:00", "12:00", "15:00", "18:00", "20:00"]
        return timeToNextPrayer(prayerTimes: prayerTimes)
    }

    func formatTimeInterval(_ interval: TimeInterval, prayerName: String) -> String {
        if interval <= 60 {
            return "\(prayerName) za \(Int(interval)) sec"
        } else {
            let hours = Int(interval) / 3600
            let minutes = (Int(interval) % 3600 + 59) / 60
            if hours > 0 {
                return "\(prayerName) za \(hours) h \(minutes) min"
            } else {
                return "\(prayerName) za \(minutes) min"
            }
        }
    }
}

