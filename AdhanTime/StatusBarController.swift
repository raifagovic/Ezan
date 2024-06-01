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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar(timer:)), userInfo: nil, repeats: true)
    }

    @objc private func updateStatusBar(timer: Timer) {
        if let (remainingTime, nextPrayerName) = fetchRemainingTime() {
            let timeString = formatTimeInterval(remainingTime, prayerName: nextPrayerName)
            statusItem.button?.title = timeString
        }
    }

    func fetchRemainingTime() -> (TimeInterval, String)? {
            let prayerTimes = ["03:30", "05:00", "12:00", "15:00", "18:00", "20:00"]
            let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]
            
            let currentTimeString = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            let currentTimeComponents = currentTimeString.split(separator: ":").compactMap { Int($0) }
            guard currentTimeComponents.count == 2 else {
                return nil
            }
            
            let currentHour = currentTimeComponents[0]
            let currentMinute = currentTimeComponents[1]
            let currentSecond = Calendar.current.component(.second, from: Date())
            let currentTimeInSeconds = (currentHour * 3600) + (currentMinute * 60) + currentSecond
            
            for (index, time) in prayerTimes.enumerated() {
                let timeComponents = time.split(separator: ":").compactMap { Int($0) }
                let prayerHour = timeComponents[0]
                let prayerMinute = timeComponents[1]
                let prayerTimeInSeconds = (prayerHour * 3600) + (prayerMinute * 60)
                
                if prayerTimeInSeconds > currentTimeInSeconds {
                    let remainingTime = TimeInterval(prayerTimeInSeconds - currentTimeInSeconds)
                    return (remainingTime, prayerNames[index])
                }
            }
            
            return nil
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

