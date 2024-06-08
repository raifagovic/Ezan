import Foundation

class PrayerTimeCalculator {
    static func calculateRemainingTime(prayerTimes: [String] = ["04:30", "06:00", "12:45", "15:30", "18:45", "20:00"]) -> (TimeInterval, String)? {
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

        // Find the next prayer time
        guard let nextPrayerTimeString = prayerTimes.first(where: {
            let components = $0.split(separator: ":")
            guard components.count == 2, let hour = Int(components[0]), let minute = Int(components[1]) else {
                return false
            }
            let prayerTimeInSeconds = (hour * 3600) + (minute * 60)
            return prayerTimeInSeconds > currentTimeInSeconds
        }) else {
            return nil
        }

        // Determine the index of the next prayer time
        guard let index = prayerTimes.firstIndex(of: nextPrayerTimeString) else {
            return nil
        }

        // Define the array of prayer names
        let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]

        // Determine the name of the next prayer
        guard index < prayerNames.count else {
            return nil
        }

        let nextPrayerTimeComponents = nextPrayerTimeString.split(separator: ":").compactMap { Int($0) }
        guard nextPrayerTimeComponents.count == 2 else {
            return nil
        }

        let nextPrayerHour = nextPrayerTimeComponents[0]
        let nextPrayerMinute = nextPrayerTimeComponents[1]

        // Convert next prayer time to seconds
        let nextPrayerTimeInSeconds = (nextPrayerHour * 3600) + (nextPrayerMinute * 60)

        // Calculate time difference in seconds
        var timeDifferenceInSeconds = nextPrayerTimeInSeconds - currentTimeInSeconds

        // Adjust for negative time difference (next prayer time is on the next day)
        if timeDifferenceInSeconds < 0 {
            timeDifferenceInSeconds += 86400 // 24 hours in seconds
        }

        return (TimeInterval(timeDifferenceInSeconds), prayerNames[index])
    }
}
