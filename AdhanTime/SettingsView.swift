//
//  SettingsView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 8. 2024..
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Location Picker Section
            LocationPickerView()
            
            // Text Section
            TextView()

            Spacer() // Pushes content to the top
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}

struct LocationPickerView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Location:")
                .font(.headline)
            Picker("Location", selection: $viewModel.selectedLocationIndex) {
                ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                    Text(name).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct TextView: View {
    var body: some View {
        Text("This is a simple text view.")
            .font(.headline)
    }
}
