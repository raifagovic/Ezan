//
//  AdhanTimeApp.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

@main
struct AdhanTimeApp: App {
    @StateObject private var viewModel = StatusBarViewModel.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            VStack {
                ContentView()
                    .environmentObject(viewModel)
                Divider()
                HStack {
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    .buttonStyle(QuitButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
        } label: {
            HStack {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                Text(viewModel.statusBarTitle)
            }
        }
        .menuBarExtraStyle(.window)
    }
}

struct QuitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(5)
            .foregroundColor(.primary)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .contentShape(Rectangle()) // Ensures the whole row is clickable
            .onHover { hovering in
                if hovering {
                    configuration.label.background(Color.blue.opacity(0.2))
                } else {
                    configuration.label.background(Color.clear)
                }
            }
    }
}

