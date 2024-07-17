//
//  StatusBarController.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 5. 2024..
//

import Cocoa
import SwiftUI

class StatusBarController {
    static let shared = StatusBarController()
    private var statusItem: NSStatusItem
    private var timer: Timer?
    private var panel: NSPanel?
    
    var remainingTime: TimeInterval?
    var nextPrayerName: String?
    var locationId: Int = 77 // Default locationId
    
    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "AdhanTime"
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
        
        refresh()
    }
    
    @objc func statusBarButtonClicked() {
        if let panel = panel, panel.isVisible {
            panel.orderOut(nil)
        } else {
            showPanel()
        }
    }
    
    func showPanel() {
        if panel == nil {
            // Create the panel
            panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
                            styleMask: [.nonactivatingPanel],
                            backing: .buffered, defer: true)
            panel?.isFloatingPanel = true
            panel?.level = .floating
            panel?.hidesOnDeactivate = true
            panel?.becomesKeyOnlyIfNeeded = true
            panel?.contentViewController = NSHostingController(rootView: ContentView())
            panel?.isOpaque = false
            panel?.hasShadow = true
            
            // Customize the panel to have rounded corners
            
            panel?.backgroundColor = .clear
            panel?.contentView?.wantsLayer = true
            panel?.contentView?.layer?.cornerRadius = 10
            panel?.contentView?.layer?.masksToBounds = true
        }
        
        if let button = statusItem.button, let panel = panel {
            let buttonFrame = button.window!.convertToScreen(button.frame)
            let panelX = buttonFrame.midX - (panel.frame.width / 2)
            let panelY = buttonFrame.minY - panel.frame.height
            panel.setFrameOrigin(NSPoint(x: panelX, y: panelY))
            panel.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func startTimer(for interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBar(timer:)), userInfo: nil, repeats: true)
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
