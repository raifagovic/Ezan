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
    private var mainWindow: NSWindow?
    
    var remainingTime: TimeInterval?
    var nextPrayerName: String?

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "Loading..."
        }
        
        startTimer()
    }
    
    func setMainWindow(_ window: NSWindow) {
        self.mainWindow = window
    }
    
    @objc func statusBarButtonClicked() {
        if let window = mainWindow {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
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
        // Recalculate remaining time and next prayer name
        if let (newRemainingTime, newNextPrayerName) = PrayerTimeCalculator.calculateRemainingTime() {
            self.remainingTime = newRemainingTime
            self.nextPrayerName = newNextPrayerName
            let timeString = TimeUtils.formatTimeInterval(newRemainingTime, prayerName: newNextPrayerName)
            updateStatusBar(title: timeString)
        }
        // Restart the timer
        startTimer()
    }
}

