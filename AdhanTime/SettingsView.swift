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
        TabView {
            LocationPickerView()
                .tabItem {
                    Label("Locations", systemImage: "location")
                }

            TextView()
                .tabItem {
                    Label("Text", systemImage: "text.bubble")
                }
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
            Picker("Location", selection: $viewModel.locationId) {
                ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                    Text(name).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
    }
}

struct TextView: View {
    var body: some View {
        VStack {
            Text("This is a simple text view.")
                .font(.headline)
            Spacer()
        }
        .padding()
    }
}
