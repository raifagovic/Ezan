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
            // First tab: Location and Format
            VStack(alignment: .leading, spacing: 20) {
                LocationPickerView()
                FormatSelectorView()
                Spacer() // Pushes content to the top
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            
            // Second tab: Software Update
            VStack {
                Text("Software Update")
                    .font(.headline)
                Text("No updates available at this moment.") // Placeholder text
                Spacer()
            }
            .tabItem {
                Label("Software Update", systemImage: "arrow.down.circle")
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
            Picker("Location", selection: $viewModel.selectedLocationIndex) {
                ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                    Text(name).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct FormatSelectorView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Status Bar Format:")
                .font(.headline)

            Toggle("Short Format", isOn: $viewModel.isShortFormat)
                .padding()
                .toggleStyle(SwitchToggleStyle())
        }
    }
}
