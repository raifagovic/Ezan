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
        
    func updateStatusBar() {
        guard let nextPrayerTimeInterval = remainingTime, let nextPrayerName = nextPrayerName else {
            statusBarTitle = "Fetch the data!"
            return
        }
        
        statusBarTitle = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
        startTimer(for: nextPrayerTimeInterval)
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
