import Foundation

class PrayerTimeCalculator {
    static func calculateRemainingTime(prayerTimes: [String] = ["04:30", "06:00", "12:45", "15:30", "18:45", "20:00"], isStandardPodneEnabled: Bool) -> (TimeInterval, String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Sarajevo")
        
        let currentTimeString = dateFormatter.string(from: Date())
        print("Current time in Sarajevo: \(currentTimeString)")
        
        let currentTimeComponents = currentTimeString.split(separator: ":").compactMap { Int($0) }
        guard currentTimeComponents.count == 2 else {
            return nil
        }
        
        let currentHour = currentTimeComponents[0]
        let currentMinute = currentTimeComponents[1]
        let currentSecond = Calendar.current.component(.second, from: Date())
        
        // Convert current time to seconds
        let currentTimeInSeconds = (currentHour * 3600) + (currentMinute * 60) + currentSecond
        
        // Define the array of prayer names
        let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]
        
        // Find the next prayer time
        var nextPrayerTimeString: String?
        var index: Int?
        for (i, timeString) in prayerTimes.enumerated() {
            var adjustedTimeString = timeString
            
            // Apply the standard Podne time if enabled
            if prayerNames[i] == "Podne", isStandardPodneEnabled {
                adjustedTimeString = getStandardPodneTime(prayerTime: timeString)
            }
            
            let components = adjustedTimeString.split(separator: ":").compactMap { Int($0) }
            guard components.count == 2 else { continue }
            let prayerTimeInSeconds = (components[0] * 3600) + (components[1] * 60)
            if prayerTimeInSeconds > currentTimeInSeconds {
                nextPrayerTimeString = adjustedTimeString
                index = i
                break
            }
        }
        
        // If no future prayer time is found for today, use the first prayer time of the next day
        if nextPrayerTimeString == nil {
            nextPrayerTimeString = prayerTimes.first
            index = 0
        }
        
        guard let validNextPrayerTimeString = nextPrayerTimeString, let validIndex = index else {
            return nil
        }
        
        // Determine the name of the next prayer
        guard validIndex < prayerNames.count else {
            return nil
        }
        
        let nextPrayerTimeComponents = validNextPrayerTimeString.split(separator: ":").compactMap { Int($0) }
        guard nextPrayerTimeComponents.count == 2 else {
            return nil
        }
        
        let nextPrayerHour = nextPrayerTimeComponents[0]
        let nextPrayerMinute = nextPrayerTimeComponents[1]
        
        // Convert next prayer time to seconds
        let nextPrayerTimeInSeconds = (nextPrayerHour * 3600) + (nextPrayerMinute * 60)
        
        // Calculate time difference in seconds
        var timeDifferenceInSeconds = nextPrayerTimeInSeconds - currentTimeInSeconds
        
        // Adjust for the next day's prayer time if needed
        if timeDifferenceInSeconds < 0 {
            timeDifferenceInSeconds += 86400 // 24 hours in seconds
        }
        
        return (TimeInterval(timeDifferenceInSeconds), prayerNames[validIndex])
    }
    
    static func subtractMinutes(from time: String, minutes: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: time) else { return nil }
        let newDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: date)!
        
        return dateFormatter.string(from: newDate)
    }
    
    static func getStandardPodneTime(prayerTime: String) -> String {
        let components = prayerTime.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return prayerTime }
        
        let hour = components[0]
        let minute = components[1]
        
        if hour == 11 {
            return "12:00"
        } else if hour == 12 && minute < 10 {
            return String(format: "12:%02d", minute)
        } else if hour == 13 && minute < 10 {
            return String(format: "13:%02d", minute)
        } else {
            return "13:00"
        }
    }
}

