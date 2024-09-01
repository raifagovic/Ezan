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
