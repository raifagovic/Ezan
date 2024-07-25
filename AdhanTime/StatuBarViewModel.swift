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
}
