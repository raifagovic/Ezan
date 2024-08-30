//
//  SettingsView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 30. 8. 2024..
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: StatusBarViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            Divider()

            // Example: Location selection
            Picker("Select Location", selection: $viewModel.selectedLocationIndex) {
                ForEach(viewModel.locationsWithIndex, id: \.0) { index, name in
                    Text(name).tag(index)
                }
            }
            .pickerStyle(InlinePickerStyle())
            .padding()

            Spacer()

            HStack {
                Spacer()
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}
