//
//  ContentView.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: StatusBarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.selectedLocationName)
                    .foregroundColor(.secondary)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            //             Display fetched prayer times with names
            if !viewModel.prayerTimes.isEmpty {
                ForEach(viewModel.prayerTimes.indices, id: \.self) { index in
                    if index < viewModel.prayerNames.count {
                        let prayerName = viewModel.prayerNames[index]
                        let prayerTime = viewModel.prayerTimes[index]
                        HStack {
                            Text(prayerName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(prayerTime)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            // Settings Button
            HStack {
                Button("Settings") {
                    openSettingsWindow()
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            
            HStack {
                Button("Quit") {
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
    
    private func openSettingsWindow() {
        let settingsView = SettingsView().environmentObject(viewModel)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Settings")
        window.contentView = NSHostingView(rootView: settingsView)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

