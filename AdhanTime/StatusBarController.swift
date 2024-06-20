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
    private var noCachedDataShown = false // New flag to prevent repetitive updates
    
    var remainingTime: TimeInterval?
    var nextPrayerName: String?
    var locationId: Int = 77 // Default locationId
    
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
        if let cachedPrayerTimes = PrayerTimeCache.loadMonthlyCachedPrayerTimes(), !cachedPrayerTimes.isEmpty {
            noCachedDataShown = false // Reset the flag if data is available
            // Use cached prayer times
            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                statusItem.button?.title = timeString
                self.remainingTime = remainingTime
                self.nextPrayerName = nextPrayerName
            }
        } else if !noCachedDataShown { // Only update to "No cached data" once
            statusItem.button?.title = "No cached data"
            noCachedDataShown = true
        }
    }

    func updateStatusBar(title: String) {
        DispatchQueue.main.async {
            self.statusItem.button?.title = title
        }
    }
    
    func refresh() {
        // Get current and next month dates
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let currentMonthComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        let nextMonthComponents = calendar.dateComponents([.year, .month], from: nextMonthDate)
        
        guard let currentYear = currentMonthComponents.year,
              let currentMonth = currentMonthComponents.month,
              let nextYear = nextMonthComponents.year,
              let nextMonth = nextMonthComponents.month else {
            return
        }
        
        // Fetch prayer times for the current month
        PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: currentYear, month: currentMonth, day: 1) { result in
            switch result {
            case .success(let times):
                // Cache the new prayer times for the current month
                PrayerTimeCache.savePrayerTimes(times, for: currentDate)
                
                // Fetch prayer times for the first week of the next month
                self.fetchNextMonthFirstWeek(nextMonthComponents: nextMonthComponents)
            case .failure(let error):
                print("Failed to fetch prayer times: \(error)")
                self.fallbackToCachedData()
            }
        }
    }
    
    func fetchNextMonthFirstWeek(nextMonthComponents: DateComponents) {
        guard let nextYear = nextMonthComponents.year,
              let nextMonth = nextMonthComponents.month else {
            return
        }
        
        // Fetch prayer times for the first week of the next month
        PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: nextYear, month: nextMonth, day: 1) { result in
            switch result {
            case .success(let times):
                let nextMonthDate = Calendar.current.date(from: nextMonthComponents)!
                PrayerTimeCache.savePrayerTimes(times, for: nextMonthDate)
            case .failure(let error):
                print("Failed to fetch prayer times for the first week of the next month: \(error)")
            }
        }
    }
    
    func fallbackToCachedData() {
        let currentDate = Date()
        if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(for: currentDate) {
            if let (nextPrayerTimeInterval, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                self.remainingTime = nextPrayerTimeInterval
                self.nextPrayerName = nextPrayerName
                let timeString = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
                self.updateStatusBar(title: timeString)
                self.startTimer()
            }
        } else {
            print("No cached prayer times available")
        }
    }
}


