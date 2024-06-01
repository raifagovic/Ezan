//
//  StatusBarController.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 5. 2024..
//

import Cocoa

class StatusBarController {
    static let shared = StatusBarController()
    
    private var statusItem: NSStatusItem
    private var timer: Timer?

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "Loading..."
        }
    }
    
    func updateStatusBar(title: String) {
        statusItem.button?.title = title
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar), userInfo: nil, repeats: true)
    }

    @objc private func updateStatusBar() {
        if let (remainingTime, nextPrayerName) = fetchRemainingTime() {
            let timeString = formatTimeInterval(remainingTime, prayerName: nextPrayerName)
            statusItem.button?.title = timeString
        }
    }

    func fetchRemainingTime() -> (TimeInterval, String)? {
        let prayerTimes = ["03:30", "05:00", "12:00", "15:00", "18:00", "20:00"]
        let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]
        
        guard let remainingTime = timeToNextPrayer(prayerTimes: prayerTimes) else {
            return nil
        }
        
        for (index, time) in prayerTimes.enumerated() {
            let timeComponents = time.split(separator: ":").compactMap { Int($0) }
            let prayerHour = timeComponents[0]
            let prayerMinute = timeComponents[1]
            let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
            
            if (prayerHour > now.hour!) || (prayerHour == now.hour! && prayerMinute > now.minute!) {
                return (remainingTime, prayerNames[index])
            }
        }
        
        // If no future prayer times are found, it means all today's prayer times have passed, return the first prayer of the next day.
        return (remainingTime, prayerNames.first ?? "")
    }

    func formatTimeInterval(_ interval: TimeInterval, prayerName: String) -> String {
        if interval <= 60 {
            return "\(prayerName) je za \(Int(interval)) sec"
        } else {
            let hours = Int(interval) / 3600
            let minutes = (Int(interval) % 3600 + 59) / 60
            if hours > 0 {
                return "\(prayerName) je za \(hours) h \(minutes) min"
            } else {
                return "\(prayerName) je za \(minutes) min"
            }
        }
    }
}

