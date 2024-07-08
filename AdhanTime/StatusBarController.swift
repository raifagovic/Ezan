//
//  StatusBarController.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 5. 2024..
//

//import Cocoa
//
//class StatusBarController {
//    static let shared = StatusBarController()
//    private var statusItem: NSStatusItem
//    private var timer: Timer?
//    private var mainWindow: NSWindow?
//    
//    var remainingTime: TimeInterval?
//    var nextPrayerName: String?
//    var locationId: Int = 77 // Default locationId
//    
//    private init() {
//        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        
//        if let button = statusItem.button {
//            button.title = "Loading..."
//            button.action = #selector(statusBarButtonClicked)
//            button.target = self
//        }
//        
//        refresh()
//    }
//    
//    func setMainWindow(_ window: NSWindow) {
//        self.mainWindow = window
//    }
//    
//    @objc func statusBarButtonClicked() {
//        if let window = mainWindow {
//            if window.isVisible {
//                window.orderOut(nil)
//            } else {
//                window.makeKeyAndOrderFront(nil)
//                NSApp.activate(ignoringOtherApps: true)
//            }
//        }
//    }
//    
//    func startTimer(for interval: TimeInterval) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar(timer:)), userInfo: nil, repeats: true)
//    }
//    
//    @objc func updateStatusBar(timer: Timer) {
//        let currentYear = Calendar.current.component(.year, from: Date())
//        let nextYear = currentYear + 1
//        
//        var prayerTimes: [String] = []
//        
//        if let currentYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) {
//            prayerTimes.append(contentsOf: currentYearTimes)
//        }
//        
//        if Calendar.current.component(.month, from: Date()) == 12,
//           let nextYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: nextYear) {
//            prayerTimes.append(contentsOf: nextYearTimes)
//        }
//        
//        if !prayerTimes.isEmpty {
//            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: prayerTimes) {
//                let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
//                statusItem.button?.title = timeString
//                self.remainingTime = remainingTime
//                self.nextPrayerName = nextPrayerName
//                startTimer(for: remainingTime)
//            }
//        } else {
//            statusItem.button?.title = "No cached data"
//        }
//    }
//
//    func updateStatusBar(title: String) {
//        DispatchQueue.main.async {
//            self.statusItem.button?.title = title
//        }
//    }
//    
//    func refresh() {
//        // Get current date
//        let currentDate = Date()
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(identifier: "GMT")!
//        let currentMonth = calendar.component(.month, from: currentDate)
//        let currentYear = calendar.component(.year, from: currentDate)
//        
//        // Check if data is already cached
//        if PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) == nil {
//            // Fetch prayer times for the current year
//            fetchPrayerTimesForYear(year: currentYear) {
//                if currentMonth == 12 {
//                    // If the current month is December, fetch prayer times for the next year
//                    self.fetchPrayerTimesForYear(year: currentYear + 1, completion: {
//                        print("Fetched prayer times for the next year")
//                    })
//                }
//            }
//        }
//    }
//    
//    func fetchPrayerTimesForYear(year: Int, completion: @escaping () -> Void) {
//            let dispatchGroup = DispatchGroup()
//            
//            for month in 1...12 {
//                dispatchGroup.enter()
//                PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: year, month: month, day: 1) { result in
//                    switch result {
//                    case .success(let times):
//                        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
//                        PrayerTimeCache.savePrayerTimes(times, for: date)
//                    case .failure(let error):
//                        print("Failed to fetch prayer times for year \(year), month \(month): \(error)")
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main) {
//                completion()
//                self.updateStatusBar(timer: Timer())
//            }
//        }
//    
//    func fallbackToCachedData() {
//        let currentDate = Date()
//        if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(for: currentDate) {
//            if let (nextPrayerTimeInterval, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
//                self.remainingTime = nextPrayerTimeInterval
//                self.nextPrayerName = nextPrayerName
//                let timeString = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
//                self.updateStatusBar(title: timeString)
//                self.startTimer(for: nextPrayerTimeInterval)
//            }
//        } else {
//            self.updateStatusBar(title: "Fetch the data!")
//        }
//    }
//}

import Cocoa

class StatusBarController {
    static let shared = StatusBarController()
    private var statusItem: NSStatusItem
    private var timer: Timer?
    private var mainWindow: NSWindow?
    
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
        
        refresh()
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
    
    func startTimer(for interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        guard var remainingTime = remainingTime else { return }
        
        if remainingTime > 0 {
            remainingTime -= 1
            let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName!)
            statusItem.button?.title = timeString
            self.remainingTime = remainingTime
        } else {
            // Fetch the next prayer time when countdown reaches zero
            fetchNextPrayerTime()
        }
    }
    
    func fetchNextPrayerTime() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let nextYear = currentYear + 1
        
        var prayerTimes: [String] = []
        
        if let currentYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) {
            prayerTimes.append(contentsOf: currentYearTimes)
        }
        
        if Calendar.current.component(.month, from: Date()) == 12,
           let nextYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: nextYear) {
            prayerTimes.append(contentsOf: nextYearTimes)
        }
        
        if !prayerTimes.isEmpty {
            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: prayerTimes) {
                self.remainingTime = remainingTime
                self.nextPrayerName = nextPrayerName
                startTimer(for: remainingTime)
                let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                statusItem.button?.title = timeString
            }
        } else {
            statusItem.button?.title = "No cached data"
        }
    }
    
    @objc func updateStatusBar(timer: Timer) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let nextYear = currentYear + 1
        
        var prayerTimes: [String] = []
        
        if let currentYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) {
            prayerTimes.append(contentsOf: currentYearTimes)
        }
        
        if Calendar.current.component(.month, from: Date()) == 12,
           let nextYearTimes = PrayerTimeCache.loadYearlyCachedPrayerTimes(for: nextYear) {
            prayerTimes.append(contentsOf: nextYearTimes)
        }
        
        if !prayerTimes.isEmpty {
            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: prayerTimes) {
                let timeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                statusItem.button?.title = timeString
                self.remainingTime = remainingTime
                self.nextPrayerName = nextPrayerName
                startTimer(for: remainingTime)
            }
        } else {
            statusItem.button?.title = "No cached data"
        }
    }

    func updateStatusBar(title: String) {
        DispatchQueue.main.async {
            self.statusItem.button?.title = title
        }
    }
    
    func refresh() {
        // Get current date
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        // Check if data is already cached
        if PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) == nil {
            // Fetch prayer times for the current year
            fetchPrayerTimesForYear(year: currentYear) {
                if currentMonth == 12 {
                    // If the current month is December, fetch prayer times for the next year
                    self.fetchPrayerTimesForYear(year: currentYear + 1, completion: {
                        print("Fetched prayer times for the next year")
                    })
                }
            }
        }
    }
    
    func fetchPrayerTimesForYear(year: Int, completion: @escaping () -> Void) {
            let dispatchGroup = DispatchGroup()
            
            for month in 1...12 {
                dispatchGroup.enter()
                PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: year, month: month, day: 1) { result in
                    switch result {
                    case .success(let times):
                        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
                        PrayerTimeCache.savePrayerTimes(times, for: date)
                    case .failure(let error):
                        print("Failed to fetch prayer times for year \(year), month \(month): \(error)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion()
                self.updateStatusBar(timer: Timer())
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
                self.startTimer(for: nextPrayerTimeInterval)
            }
        } else {
            self.updateStatusBar(title: "Fetch the data!")
        }
    }
}

