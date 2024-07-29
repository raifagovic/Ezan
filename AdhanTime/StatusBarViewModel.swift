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
        refresh()
    }

    func startTimer() {
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
                self.fetchPrayerTimesForToday {
                    self.updateStatusBar()
                }
            }
        }
    }
    
    func updateStatusBar() {
        guard let remainingTime = self.remainingTime, let nextPrayerName = self.nextPrayerName else {
            self.statusBarTitle = "No cached data"
            return
        }
        self.statusBarTitle = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
    }
    
    func refresh() {
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        
        if !isYearCached(year: currentYear) {
            fetchPrayerTimesForYear(year: currentYear) {
                self.fetchPrayerTimesForToday {
                    self.updateStatusBar()
                }
            }
        } else {
            fetchPrayerTimesForToday {
                self.updateStatusBar()
            }
        }
    }
    
    func isYearCached(year: Int) -> Bool {
        let calendar = Calendar.current
        for month in 1...12 {
            let daysInMonth = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(year: year, month: month))!)?.count ?? 0
            for day in 1...daysInMonth {
                let components = DateComponents(year: year, month: month, day: day)
                if let date = calendar.date(from: components),
                   PrayerTimeCache.loadCachedPrayerTimes(for: date) == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func fetchPrayerTimesForYear(year: Int, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for month in 1...12 {
            // Create DateComponents for the start of the month
            var components = DateComponents()
            components.year = year
            components.month = month
            
            // Safely create a date from the components
            guard let startOfMonth = Calendar.current.date(from: components) else {
                print("Failed to create date for year \(year), month \(month)")
                continue
            }
            // Determine the range of days for the current month
            let daysInMonth = Calendar.current.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
            
            for day in 1...daysInMonth {
                dispatchGroup.enter()
                PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: year, month: month, day: day) { result in
                    switch result {
                    case .success(let times):
                        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
                        PrayerTimeCache.savePrayerTimes(times, for: date)
                    case .failure(let error):
                        print("Failed to fetch prayer times for year \(year), month \(month), day \(day): \(error)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
            self.updateStatusBar()
        }
    }
    
    func fetchPrayerTimesForToday(completion: @escaping () -> Void) {
        let today = Date()
        if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(for: today) {
            if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(prayerTimes: cachedPrayerTimes) {
                self.remainingTime = remainingTime
                self.nextPrayerName = nextPrayerName
                startTimer()
                completion()
            } else {
                print("Failed to calculate remaining time.")
                completion()
            }
        } else {
            print("No cached data for today.")
            completion()
        }
    }
}
