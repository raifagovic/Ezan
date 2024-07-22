//
//  AdhanTimeApp.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

@main
struct AdhanTimeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("AdhanTime", systemImage: "clock") {
            ContentView()
        }
        .menuBarExtraStyle(.window) // Use the window style for rounded corners
    }
}
