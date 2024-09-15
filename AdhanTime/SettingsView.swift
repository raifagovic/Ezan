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
                SubtractionSliderView()
                FormatSelectorView()
                StandardPodneToggleView()
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
        .frame(width: 300, height: 400)
    }
}

struct LocationPickerView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Location", selection: $viewModel.selectedLocationIndex) {
                ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                    Text(name).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct SubtractionSliderView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Subtract \(viewModel.sabahSubtractionMinutes) min from Izlazak Sunca")
                    .font(.subheadline)

                Spacer()
                
                Text("\(viewModel.sabahSubtractionMinutes) min")
                    .font(.subheadline)
                    .padding(.trailing)
            }

            Slider(value: Binding(
                get: { Double(viewModel.sabahSubtractionMinutes) },
                set: { viewModel.sabahSubtractionMinutes = Int($0) }
            ), in: 15...60, step: 5)
        }
        .padding()
    }
}

struct FormatSelectorView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Short Format", isOn: $viewModel.isShortFormat)
                .padding()
                .toggleStyle(SwitchToggleStyle())
        }
    }
}

struct StandardPodneToggleView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        Toggle("Use Standard Podne Time", isOn: $viewModel.isStandardPodneEnabled)
            .toggleStyle(SwitchToggleStyle())
    }
}
