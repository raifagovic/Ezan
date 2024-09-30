//
//  ContentView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel
    var appDelegate: AppDelegate
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.selectedLocationName)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            // Display fetched prayer times with names
            if !viewModel.prayerTimes.isEmpty {
                ForEach(viewModel.adjustedPrayerTimes.indices, id: \.self) { index in
                    let prayer = viewModel.adjustedPrayerTimes[index]
                    HStack {
                        Text(prayer.name)
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(prayer.time)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                }
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            // Settings Button
            HStack {
                Button("Postavke") {
                    appDelegate.openSettingsWindow()
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            HStack {
                Button("Izlaz") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(HoverButtonStyle())
            }
        }
        .padding(5)
        .frame(maxWidth: 180, alignment: .leading)
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
}

