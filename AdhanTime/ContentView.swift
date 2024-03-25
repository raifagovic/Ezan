//
//  ContentView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLocation: String = "Sarajevo"
    
    let locations = [
        "Banovići", "Banja Luka", "Bihać", "Bijeljina", "Bileća", "Bosanski Brod", "Bosanska Dubica", "Bosanska Gradiška", "Bosansko Grahovo", "Bosanska Krupa", "Bosanski Novi", "Bosanski Petrovac", "Bosanski Šamac", "Bratunac", "Brčko", "Breza", "Bugojno", "Busovača", "Bužim", "Cazin", "Čajniče", "Čapljina", "Čelić", "Čelinac", "Čitluk", "Derventa", "Doboj", "Donji Vakuf", "Drvar", "Foča", "Fojnica", "Gacko", "Glamoč", "Goražde", "Gornji Vakuf", "Gračanica", "Gradačac", "Grude", "Hadžići", "Han-Pijesak", "Hlivno", "Ilijaš", "Jablanica", "Jajce", "Kakanj", "Kalesija", "Kalinovik", "Kiseljak", "Kladanj", "Ključ", "Konjic", "Kotor-Varoš", "Kreševo", "Kupres", "Laktaši", "Lopare", "Lukavac", "Ljubinje", "Ljubuški", "Maglaj", "Modriča", "Mostar", "Mrkonjić-Grad", "Neum", "Nevesinje", "Novi Travnik", "Odžak", "Olovo", "Orašje", "Pale", "Posušje", "Prijedor", "Prnjavor", "Prozor", "Rogatica", "Rudo", "Sanski Most", "Sarajevo", "Skender-Vakuf", "Sokolac", "Srbac", "Srebrenica", "Srebrenik", "Stolac", "Šekovići", "Šipovo", "Široki Brijeg", "Teslić", "Tešanj", "Tomislav-Grad", "Travnik", "Trebinje", "Trnovo", "Tuzla", "Ugljevik", "Vareš", "Velika Kladuša", "Visoko", "Višegrad", "Vitez", "Vlasenica", "Zavidovići", "Zenica", "Zvornik", "Žepa", "Žepče", "Živinice", "Bijelo Polje", "Gusinje", "Nova Varoš", "Novi Pazar", "Plav", "Pljevlja", "Priboj", "Prijepolje", "Rožaje", "Sjenica", "Tutin"
    ]
    
    let prayerTimes = ["3:38", "5:35", "12:00", "15:21", "20:08", "21:50"]
    
    init() {
        if let timeToNext = timeToNextPrayer(prayerTimes: prayerTimes) {
            print("Time to next adhan:", timeToNext)
        } else {
            print("No prayer times remaining for the day.")
        }
    }
    
    var body: some View {
        VStack {
            Text("Adhan Time")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Add location selection UI
            Picker("Select Location", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Spacer()
            
            // Add time to next prayer UI
            let timeToNextPrayerResult = timeToNextPrayer(prayerTimes: prayerTimes)
            Text("Time to Next Prayer: \(timeToNextPrayerResult ?? "Unknown")")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

