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
    
    var remainingTime: TimeInterval?
    var nextPrayerName: String?

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "Loading..."
        }
        
        startTimer()
    }
 
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar(timer:)), userInfo: nil, repeats: true)
    }

    @objc func updateStatusBar(timer: Timer) {
        if let remainingTime = remainingTime, let nextPrayerName = nextPrayerName {
            let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
            statusItem.button?.title = timeString
        }
    }
    
    func updateStatusBar(title: String) {
        statusItem.button?.title = title
    }

    func refresh() {
        startTimer()
    }
}

