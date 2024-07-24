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

    init() {
        fetchPrayerTimes()
    }

    func fetchPrayerTimes() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: currentYear, month: currentMonth, day: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch prayer times: \(error)")
                    self.statusBarTitle = "Fetch failed"
                case .finished:
                    break
                }
            }, receiveValue: { times in
                self.handleFetchedPrayerTimes(times)
            })
            .store(in: &cancellables)
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let currentRemainingTime = self.remainingTime else {
                return
            }

            if currentRemainingTime > 0 {
                self.remainingTime = currentRemainingTime - 1
                self.statusBarTitle = TimeUtils.formatTimeInterval(currentRemainingTime - 1, prayerName: self.nextPrayerName ?? "")
            } else {
                self.timer?.invalidate()
                self.fetchPrayerTimes()
            }
        }
    }
}
