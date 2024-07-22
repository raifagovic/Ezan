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
        // Implement your fetch logic here
        // For demo purposes, simulate fetched prayer times
        self.remainingTime = 3600 // Example remaining time of 1 hour
        self.nextPrayerName = "Fajr" // Example next prayer name
        updateStatusBar()
    }

    func updateStatusBar() {
        if let nextPrayerTimeInterval = remainingTime, let nextPrayerName = nextPrayerName {
            statusBarTitle = TimeUtils.formatTimeInterval(nextPrayerTimeInterval, prayerName: nextPrayerName)
        } else {
            statusBarTitle = "Fetch the data!"
        }
        startTimer(for: remainingTime)
    }

    func startTimer(for interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.statusBarTitle = TimeUtils.formatTimeInterval(self.remainingTime, prayerName: self.nextPrayerName ?? "")
            } else {
                self.timer?.invalidate()
                self.fetchPrayerTimes()
            }
        }
    }
}
