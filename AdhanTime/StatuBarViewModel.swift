//
//  StatuBarViewModel.swift
//  AdhanTime
//
//  Created by Raif Agovic on 22. 7. 2024..
//

import SwiftUI
import Combine

class StatusBarViewModel: ObservableObject {
    @Published var statusBarTitle: String = "AdhanTime"
    @Published var remainingTime: TimeInterval?
    @Published var nextPrayerName: String?
    private var timer: Timer?
    private var locationId: Int = 77

    init() {
        fetchPrayerTimes()
    }

    func startTimer(for interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let currentRemainingTime = self.remainingTime else {
                self.timer?.invalidate()
                return
            }
            
            if currentRemainingTime > 0 {
                self.remainingTime = currentRemainingTime - 1
                self.statusBarTitle = TimeUtils.formatTimeInterval(currentRemainingTime - 1, prayerName: self.nextPrayerName ?? "")
            } else {
                self.timer?.invalidate()
                self.fetchPrayerTimesForYear(year: Calendar.current.component(.year, from: Date())) {
                    // Update the status bar after fetching the prayer times
                    self.updateStatusBar()
                }
            }
        }
    }
    
    func updateStatusBar() {
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
                self.statusBarTitle = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
                startTimer(for: remainingTime)
            }
        } else {
            self.statusBarTitle = "No cached data"
        }
    }
    
    func refresh() {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        if PrayerTimeCache.loadYearlyCachedPrayerTimes(for: currentYear) == nil {
            fetchPrayerTimesForYear(year: currentYear) {
                if currentMonth == 12 {
                    self.fetchPrayerTimesForYear(year: currentYear + 1) {
                        print("Fetched prayer times for the next year")
                    }
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
            self.updateStatusBar()
        }
    }
    
    func fallbackToCachedData() {
        let currentDate = Date()
        if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(for: currentDate) {
            if let (nextPrayerTimeInterval, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                self.remainingTime = nextPrayerTimeInterval
                self.nextPrayerName = nextPrayerName
                let timeString = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
                self.statusBarTitle = timeString
                startTimer(for: nextPrayerTimeInterval)
            }
        } else {
            self.statusBarTitle = "Fetch the data!"
        }
    }
}
