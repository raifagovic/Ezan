//
//  ContentView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Adhan Time")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Add location selection UI here
            Picker("Select Location", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            
            Spacer()
            
            // Add time to next prayer UI here
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

