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
                VStack(alignment: .leading, spacing: 10) {
                    LocationPickerView()
                    Divider()
                    SubtractionSliderView()
                    Divider()
                    FormatSelectorView()
                    Divider()
                    StandardPodneToggleView()
                }
                .padding()
                Spacer()
            }
            .tabItem {
                Label("Postavke", systemImage: "gearshape")
            }
            
            // Second tab: Software Update
            VStack {
                Text("Kontakt:")
                Text("raif.agovic.dev@gmail.com") // Placeholder text
                Spacer()
            }
            .padding()
            .tabItem {
                Label("Prijavi grešku", systemImage: "arrow.down.circle")
            }
        }
        .padding()
        .frame(width: 350, height: 300)
    }
}

struct LocationPickerView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Lokacija")
                Spacer()
                Picker("", selection: $viewModel.selectedLocationIndex) {
                    ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                        Text(name).tag(index)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .frame(maxWidth: 150) // Limit width for the picker to keep it compact
            }
        }
    }
}

struct SubtractionSliderView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Vrijeme Sabah namaza")
                
            Spacer()
            
            Text("\(viewModel.sabahSubtractionMinutes) min prije izlaska Sunca")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Slider(value: Binding(
                get: { Double(viewModel.sabahSubtractionMinutes) },
                set: { viewModel.sabahSubtractionMinutes = Int($0) }
            ), in: 15...60, step: 5)
        }
    }
}

struct FormatSelectorView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        HStack {
            Text("Skraćeni prikaz u Menu Baru")
            Spacer()
            Toggle("", isOn: $viewModel.isShortFormat)
                .toggleStyle(SwitchToggleStyle())
        }
    }
}

struct StandardPodneToggleView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        HStack {
            Text("Standardno vrijeme za Podne")
            Spacer()
            Toggle("", isOn: $viewModel.isStandardPodneEnabled)
                .toggleStyle(SwitchToggleStyle())
        }
    }
}
