//
//  StatusBarViewModel.swift
//  AdhanTime
//
//  Created by Raif Agovic on 25. 8. 2024..
//

import SwiftUI
import Combine
class StatusBarViewModel: ObservableObject {
    static let shared = StatusBarViewModel()

    @Published var statusBarTitle: String = "AdhanTime"
    @Published var remainingTime: TimeInterval?
    @Published var prayerTimes: [String] = []
    @Published var nextPrayerName: String?
    @Published var isShortFormat: Bool = false
    @Published var sabahSubtractionMinutes: Int = 45
    @Published var isStandardPodneEnabled: Bool = false
    
    @Published var selectedLocationIndex: Int = 0 {
        didSet {
            // Update locationId based on the new selectedLocationIndex
            self.locationId = locationsWithIndex[selectedLocationIndex].0
            
            // Refresh the prayer times for the new location
            refresh()
        }
    }
    
    let locationsWithIndex: [(Int, String)] = [
        (0, "Banovići"),
        (1, "Banja Luka"),
        (2, "Bihać"),
        (3, "Bijeljina"),
        (4, "Bileća"),
        (5, "Bosanski Brod"),
        (6, "Bosanska Dubica"),
        (7, "Bosanska Gradiška"),
        (8, "Bosansko Grahovo"),
        (9, "Bosanska Krupa"),
        (10, "Bosanski Novi"),
        (11, "Bosanski Petrovac"),
        (12, "Bosanski Šamac"),
        (13, "Bratunac"),
        (14, "Brčko"),
        (15, "Breza"),
        (16, "Bugojno"),
        (17, "Busovača"),
        (18, "Bužim"),
        (19, "Cazin"),
        (20, "Čajniče"),
        (21, "Čapljina"),
        (22, "Čelić"),
        (23, "Čelinac"),
        (24, "Čitluk"),
        (25, "Derventa"),
        (26, "Doboj"),
        (27, "Donji Vakuf"),
        (28, "Drvar"),
        (29, "Foča"),
        (30, "Fojnica"),
        (31, "Gacko"),
        (32, "Glamoč"),
        (33, "Goražde"),
        (34, "Gornji Vakuf"),
        (35, "Gračanica"),
        (36, "Gradačac"),
        (37, "Grude"),
        (38, "Hadžići"),
        (39, "Han-Pijesak"),
        (40, "Hlivno"),
        (41, "Ilijaš"),
        (42, "Jablanica"),
        (43, "Jajce"),
        (44, "Kakanj"),
        (45, "Kalesija"),
        (46, "Kalinovik"),
        (47, "Kiseljak"),
        (48, "Kladanj"),
        (49, "Ključ"),
        (50, "Konjic"),
        (51, "Kotor-Varoš"),
        (52, "Kreševo"),
        (53, "Kupres"),
        (54, "Laktaši"),
        (55, "Lopare"),
        (56, "Lukavac"),
        (57, "Ljubinje"),
        (58, "Ljubuški"),
        (59, "Maglaj"),
        (60, "Modriča"),
        (61, "Mostar"),
        (62, "Mrkonjić-Grad"),
        (63, "Neum"),
        (64, "Nevesinje"),
        (65, "Novi Travnik"),
        (66, "Odžak"),
        (67, "Olovo"),
        (68, "Orašje"),
        (69, "Pale"),
        (70, "Posušje"),
        (71, "Prijedor"),
        (72, "Prnjavor"),
        (73, "Prozor"),
        (74, "Rogatica"),
        (75, "Rudo"),
        (76, "Sanski Most"),
        (77, "Sarajevo"),
        (78, "Skender-Vakuf"),
        (79, "Sokolac"),
        (80, "Srbac"),
        (81, "Srebrenica"),
        (82, "Srebrenik"),
        (83, "Stolac"),
        (84, "Šekovići"),
        (85, "Šipovo"),
        (86, "Široki Brijeg"),
        (87, "Teslić"),
        (88, "Tešanj"),
        (89, "Tomislav-Grad"),
        (90, "Travnik"),
        (91, "Trebinje"),
        (92, "Trnovo"),
        (93, "Tuzla"),
        (94, "Ugljevik"),
        (95, "Vareš"),
        (96, "Velika Kladuša"),
        (97, "Visoko"),
        (98, "Višegrad"),
        (99, "Vitez"),
        (100, "Vlasenica"),
        (101, "Zavidovići"),
        (102, "Zenica"),
        (103, "Zvornik"),
        (104, "Žepa"),
        (105, "Žepče"),
        (106, "Živinice"),
        (107, "Bijelo Polje"),
        (108, "Gusinje"),
        (109, "Nova Varoš"),
        (110, "Novi Pazar"),
        (111, "Plav"),
        (112, "Pljevlja"),
        (113, "Priboj"),
        (114, "Prijepolje"),
        (115, "Rožaje"),
        (116, "Sjenica"),
        (117, "Tutin")
    ]
    
    let prayerNames = ["Zora", "Izlazak Sunca", "Podne", "Ikindija", "Akšam", "Jacija"]
    
    private var timer: Timer?
    private(set) var locationId: Int
    private var isInitialized = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Initialize the stored properties first
        self.locationId = 77 // Default value, e.g., Sarajevo's ID
        self.sabahSubtractionMinutes = 45 // Default subtraction for Sabah
        
        // After initializing stored properties, load settings from UserDefaults
        loadSettingsFromUserDefaults()
        
        let defaults = UserDefaults.standard

        // Check if location was loaded from UserDefaults; if not, set the default Sarajevo location
        if defaults.object(forKey: "selectedLocationIndex") == nil {
            if let index = locationsWithIndex.firstIndex(where: { $0.0 == 77 }) {
                self.selectedLocationIndex = index
                self.locationId = 77
            }
        }

        // Check if sabahSubtractionMinutes was loaded from UserDefaults; if not, set the default value
        if defaults.object(forKey: "sabahSubtractionMinutes") == nil {
            self.sabahSubtractionMinutes = 45 // Default subtraction for Sabah
        }

        // Automatically save settings whenever any of the @Published properties change
        setupAutoSave()

        if !isInitialized {
            print("Initializing ViewModel and refreshing")
            refresh()
            isInitialized = true
        }
    }
    
    var selectedLocationName: String {
        locationsWithIndex[selectedLocationIndex].1
    }
    
    var adjustedPrayerTimes: [(name: String, time: String)] {
        // Make sure there are enough prayer times
        guard prayerTimes.count >= 2 else { return [] }
        
        var adjustedTimes = [(name: String, time: String)]()
        
        // Calculate "Sabah" time by subtracting minutes from "Izlazak Sunca"
        if let izlazakSuncaIndex = prayerNames.firstIndex(of: "Izlazak Sunca"),
           let izlazakSuncaTime = PrayerTimeCalculator.subtractMinutes(from: prayerTimes[izlazakSuncaIndex], minutes: sabahSubtractionMinutes) {
            adjustedTimes.append(("Sabah", izlazakSuncaTime))
        }
        
        // Add remaining prayer names and times, skipping "Zora" and "Izlazak Sunca"
        let remainingPrayerNames = Array(prayerNames[2...])
        let remainingPrayerTimes = Array(prayerTimes[2...])
        
        for (name, time) in zip(remainingPrayerNames, remainingPrayerTimes) {
            var adjustedTime = time
            
            // Check if 'Podne' and if the standard time option is enabled
            if name == "Podne", isStandardPodneEnabled {
                adjustedTime = PrayerTimeCalculator.getStandardPodneTime(prayerTime: time)
            }
            
            adjustedTimes.append((name, adjustedTime))
        }
        
        return adjustedTimes
    }
    
    func setupAutoSave() {
        $isShortFormat
            .sink { [weak self] _ in self?.saveSettingsToUserDefaults() }
            .store(in: &cancellables)
        
        $sabahSubtractionMinutes
            .sink { [weak self] _ in self?.saveSettingsToUserDefaults() }
            .store(in: &cancellables)
        
        $isStandardPodneEnabled
            .sink { [weak self] _ in self?.saveSettingsToUserDefaults() }
            .store(in: &cancellables)
        
        $selectedLocationIndex
            .sink { [weak self] _ in self?.saveSettingsToUserDefaults() }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            // Get the current time in Sarajevo
            let currentTime = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "Europe/Sarajevo")
            
            let currentTimeString = dateFormatter.string(from: currentTime)
            print("Current time in Sarajevo: \(currentTimeString)")
            
            // Recalculate the remaining time dynamically
            let prayerTimesOnly = self.adjustedPrayerTimes.map { $0.time }
            guard let (remainingTime, nextPrayer) = PrayerTimeCalculator.calculateRemainingTime(adjustedPrayerTimes: prayerTimesOnly, isStandardPodneEnabled: self.isStandardPodneEnabled) else {
                self.timer?.invalidate()
                return
            }
            
            self.remainingTime = remainingTime
            self.nextPrayerName = nextPrayer
            
            // Update the status bar title based on the new remaining time
            self.statusBarTitle = TimeUtils.formatTimeInterval(
                remainingTime,
                prayerName: nextPrayer,
                isShortFormat: self.isShortFormat
            )
            
            // If no time is left for the current prayer, fetch the next prayer time
            if remainingTime <= 0 {
                self.fetchPrayerTimesForToday {
                    self.updateStatusBar()
                }
            }
        }
    }
    
    func updateStatusBar() {
        // Retrieve the remaining time and next prayer, pass isStandardPodneEnabled
        if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(
            adjustedPrayerTimes: self.adjustedPrayerTimes.map { $0.time }, isStandardPodneEnabled: self.isStandardPodneEnabled
        ) {
            DispatchQueue.main.async { [weak self] in
                self?.remainingTime = remainingTime

                var displayPrayerName: String

                // Skip "Zora" and show "Sabah", skip "Izlazak Sunca" and show "Podne"
                if nextPrayerName == "Zora" {
                    displayPrayerName = "Sabah"
                } else if nextPrayerName == "Izlazak Sunca" {
                    displayPrayerName = "Podne"
                } else {
                    displayPrayerName = nextPrayerName
                }

                // Update the status bar title using the formatted time
                if self?.isShortFormat == true {
                    // Short format omits prayer name and shows only remaining time
                    self?.statusBarTitle = "\(TimeUtils.formatTimeInterval(self?.remainingTime ?? 0, prayerName: "", isShortFormat: true))"
                } else {
                    // Long format includes prayer name and remaining time
                    self?.statusBarTitle = "\(TimeUtils.formatTimeInterval(self?.remainingTime ?? 0, prayerName: displayPrayerName, isShortFormat: false))"
                }
            }
        }
    }
    
    func refresh() {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Sarajevo")!
        
        // Fetch today's prayer times first, either from cache or API
        fetchPrayerTimesForToday {
            self.updateStatusBar()
        }
        
        // Check if the data for the year has already been fetched
        let currentYear = calendar.component(.year, from: currentDate)
        if !isYearDataCached(for: currentYear) {
            // Fetch the entire year's prayer times in the background only if not cached
            DispatchQueue.global(qos: .background).async {
                self.fetchPrayerTimesForYear(year: currentYear) {
                    DispatchQueue.main.async {
                        // Optionally, update the UI or show a message when year data is fully fetched
                        print("Background fetch for the year completed.")
                    }
                }
            }
        }
    }
    
    func fetchPrayerTimesForYear(year: Int, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let calendar = Calendar.current
        
        for month in 1...12 {
            let daysInMonth = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(year: year, month: month))!)?.count ?? 0
            for day in 1...daysInMonth {
                dispatchGroup.enter()
                PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: year, month: month, day: day) { result in
                    switch result {
                    case .success(let times):
                        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
                        PrayerTimeCache.savePrayerTimes(times, for: date, locationId: self.locationId)
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
            
            // First, check if cached prayer times for today are available
            if let cachedPrayerTimes = PrayerTimeCache.loadCachedPrayerTimes(for: today, locationId: self.locationId) {
        
                // Use cached data if available
                self.prayerTimes = cachedPrayerTimes
                
                // Update prayer times to cache prayer times to get correct adjusted prayer times because they depend on the prayer times
                if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(
                    adjustedPrayerTimes: adjustedPrayerTimes.map { $0.time }, isStandardPodneEnabled: self.isStandardPodneEnabled
                ) {
                    self.remainingTime = remainingTime
                    self.nextPrayerName = nextPrayerName
                    startTimer()
                }
                completion()
            } else {
                // If no cached data, fetch today's data from the API
                let calendar = Calendar.current
                let year = calendar.component(.year, from: today)
                let month = calendar.component(.month, from: today)
                let day = calendar.component(.day, from: today)
                
                PrayerTimeAPI.fetchPrayerTimes(for: locationId, year: year, month: month, day: day) { result in
                    switch result {
                    case .success(let times):
                        // Save fetched prayer times to the cache
                        PrayerTimeCache.savePrayerTimes(times, for: today, locationId: self.locationId)
                        
                        // Update the ViewModel with the fetched data
                        self.prayerTimes = times
                        if let (remainingTime, nextPrayerName) = PrayerTimeCalculator.calculateRemainingTime(
                            adjustedPrayerTimes: self.adjustedPrayerTimes.map { $0.time },
                            isStandardPodneEnabled: self.isStandardPodneEnabled
                        ) {
                            self.remainingTime = remainingTime
                            self.nextPrayerName = nextPrayerName
                            self.startTimer()
                        }
                        
                    case .failure(let error):
                        print("Failed to fetch today's prayer times: \(error)")
                    }
                    completion()
                }
            }
        }
    
    func isYearDataCached(for year: Int) -> Bool {
        let calendar = Calendar.current
        // Check the first day of each month to determine if the year's data is cached
        for month in 1...12 {
            let date = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            if PrayerTimeCache.loadCachedPrayerTimes(for: date, locationId: self.locationId) == nil {
                // If any month is missing cached data, return false
                return false
            }
        }
        return true
    }
    
    func saveSettingsToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(selectedLocationIndex, forKey: "selectedLocationIndex")
        defaults.set(sabahSubtractionMinutes, forKey: "sabahSubtractionMinutes")
        defaults.set(isShortFormat, forKey: "isShortFormat")
        defaults.set(isStandardPodneEnabled, forKey: "isStandardPodneEnabled")
    }
    
    func loadSettingsFromUserDefaults() {
        let defaults = UserDefaults.standard
        selectedLocationIndex = defaults.integer(forKey: "selectedLocationIndex")
        sabahSubtractionMinutes = defaults.integer(forKey: "sabahSubtractionMinutes")
        isShortFormat = defaults.bool(forKey: "isShortFormat")
        isStandardPodneEnabled = defaults.bool(forKey: "isStandardPodneEnabled")
    }
}
