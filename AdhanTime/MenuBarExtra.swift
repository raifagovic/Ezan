//
//  MenuBarExtra.swift
//  AdhanTime
//
//  Created by Raif Agovic on 21. 7. 2024..
//

import SwiftUI

@main
struct YourApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("AdhanTime", systemImage: "clock") {
            ContentView()
        }
    }
}
