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
    
    private let prayerTimeCache = PrayerTimeCache()

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "Loading..."
            button.action = #selector(statusBarButtonClicked)
            button.target = self
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
        if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(), !cachedPrayerTimes.isEmpty {
            // Use cached prayer times
            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                statusItem.button?.title = timeString
                self.remainingTime = remainingTime
                self.nextPrayerName = nextPrayerName
            }
        } else {
            // Fallback if no cached data is available (should rarely happen)
            statusItem.button?.title = "No cached data"
        }
    }

    func updateStatusBar(title: String) {
        statusItem.button?.title = title
    }

    func refresh() {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        guard let year = components.year, let month = components.month, let day = components.day else {
            return
        }
        
        // Assume you have a selected location ID or define a default one
        let selectedLocationId = 77 // Example: Sarajevo location ID
        
        // Try to fetch new prayer times from the internet
        PrayerTimeAPI.fetchPrayerTimes(for: selectedLocationId, year: year, month: month, day: day) { result in
            switch result {
            case .success(let times):
                // Cache the new prayer times
                PrayerTimeCache.savePrayerTimes(times)
                
                // Update status bar
                if let (newRemainingTime, newNextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: times) {
                    self.remainingTime = newRemainingTime
                    self.nextPrayerName = newNextPrayerName
                    let timeString = TimeUtils.formatTimeInterval(newRemainingTime, prayerName: newNextPrayerName)
                    self.updateStatusBar(title: timeString)
                }
            case .failure(let error):
                print("Failed to fetch prayer times: \(error)")
                // If fetching fails, continue using cached data if available
                if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(), !cachedPrayerTimes.isEmpty {
                    if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                        let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                        self.updateStatusBar(title: timeString)
                        self.remainingTime = remainingTime
                        self.nextPrayerName = nextPrayerName
                    }
                } else {
                    // If no cached data is available and fetching fails, handle appropriately
                    self.updateStatusBar(title: "No data available")
                }
            }
        }
    }
}

