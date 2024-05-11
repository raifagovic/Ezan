//
//  ContentView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLocationIndex: Int = 0
    @State private var prayerTimes: [String] = []
    @State private var timeToNextPrayerResult: String? = nil
    
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
    
    init() {
        // Find the index of "Sarajevo" in the locations array
        if let index = locationsWithIndex.firstIndex(where: { $0.1 == "Sarajevo" }) {
            self._selectedLocationIndex = State(initialValue: index)
        }
    }
    
    var selectedLocationId: Int {
        locationsWithIndex[selectedLocationIndex].0
    }

    var body: some View {
        VStack {

            Picker("Izaberi lokaciju", selection: $selectedLocationIndex) {
                ForEach(locationsWithIndex.indices, id: \.self) { index in
                    Text(locationsWithIndex[index].1)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.bottom, 50)
            .onChange(of: selectedLocationIndex) {
                fetchPrayerTimes()
            }
            
            // Display time to next prayer
            if let timeToNextPrayerResult = timeToNextPrayerResult {
                Text("\(timeToNextPrayerResult)")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.bottom, 40)
            } else {
                Text("No prayer times remaining for the day.")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 40)
            }
            
            // Display fetched prayer times with names
            if !prayerTimes.isEmpty {
                ForEach(prayerTimes.indices, id: \.self) { index in
                    if index < prayerNames.count {
                        let prayerName = prayerNames[index]
                        let prayerTime = prayerTimes[index]
                        HStack {
                            Text(prayerName)
                                .font(.subheadline)
                                .frame(width: 45, alignment: .leading)
                                .padding(.trailing, 5)
                            Text(prayerTime)
                                .font(.subheadline)
                                .frame(width: 45, alignment: .trailing)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .padding(.bottom, 30)
        .onAppear {
            // Fetch prayer times and calculate time to next prayer when the view appears
            fetchPrayerTimes()
        }
    }
    
    func fetchPrayerTimes() {
        // Fetch prayer times for the selected location
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        guard let year = components.year, let month = components.month, let day = components.day else {
            return
        }
        
        PrayerTimeAPI.fetchPrayerTimes(for: selectedLocationId, year: year, month: month, day: day) { result in
            switch result {
            case .success(let times):
                // Update the prayer times array
                DispatchQueue.main.async {
                    self.prayerTimes = times
                }
                
                // Calculate the time to next prayer
                if let nextPrayerTime = timeToNextPrayer(prayerTimes: times) {
                    // Update the time to next prayer result
                    DispatchQueue.main.async {
                        self.timeToNextPrayerResult = nextPrayerTime
                    }
                } else {
                    // If no prayer times are available, set the result to nil
                    DispatchQueue.main.async {
                        self.timeToNextPrayerResult = nil
                    }
                }
            case .failure(let error):
                print("Failed to fetch prayer times: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

