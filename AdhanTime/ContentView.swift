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
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var nextPrayerName: String? = nil
    @State private var showLocationsMenu = false
    @EnvironmentObject var viewModel: StatusBarViewModel
    
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
    
    var selectedLocationName: String {
        locationsWithIndex[selectedLocationIndex].1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(selectedLocationName)
                    .font(.body)
                    .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding(.trailing, 8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showLocationMenu()
            }
            .background(Color.clear)
            .padding(.vertical, 5)
            
//             Display fetched prayer times with names
            if !viewModel.prayerTimes.isEmpty {
                ForEach(viewModel.prayerTimes.indices, id: \.self) { index in
                    if index < prayerNames.count {
                        let prayerName = prayerNames[index]
                        let prayerTime = viewModel.prayerTimes[index]
                        HStack {
                            Text(prayerName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(prayerTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            // Settings Button
            HStack {
                Button("Settings") {
//                    openSettingsWindow()
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            HStack {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(HoverButtonStyle())
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func showLocationMenu() {
        let coordinator = Coordinator(parent: self)
        let menu = NSMenu()
        
        for (index, location) in locationsWithIndex {
            let menuItem = NSMenuItem(title: location, action: #selector(Coordinator.selectLocation(_:)), keyEquivalent: "")
            menuItem.tag = index
            menuItem.target = coordinator
            menu.addItem(menuItem)
        }
        
        if let window = NSApplication.shared.keyWindow {
            let mouseLocation = NSEvent.mouseLocation
            let locationInWindow = window.convertFromScreen(NSRect(origin: mouseLocation, size: .zero)).origin
            menu.popUp(positioning: nil, at: locationInWindow, in: window.contentView)
        }
    }
    
    // Coordinator Class for handling the menu actions
        class Coordinator: NSObject {
            var parent: ContentView
            
            init(parent: ContentView) {
                self.parent = parent
            }
            
            @objc func selectLocation(_ sender: NSMenuItem) {
                parent.selectedLocationIndex = sender.tag
            }
        }
}

struct HoverButtonStyle: ButtonStyle {
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(isHovering ? Color.black.opacity(0.1) : Color.clear)
                .cornerRadius(4)
                .onHover { hovering in
                    isHovering = hovering
                }
    }
}
