//
//  PrayerTimeViewModel.swift
//  AdhanTime
//
//  Created by Raif Agovic on 6. 6. 2024..
//

import SwiftUI

class PrayerTimeViewModel: ObservableObject {
    @Published var prayerTimeString: String = ""
    
    func refreshPrayerTime() {
        if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime() {
            prayerTimeString = TimeUtils.formatTimeInterval(remainingTime, prayerName: nextPrayerName)
        } else {
            prayerTimeString = "Nema više ezana danas"
        }
    }
}

