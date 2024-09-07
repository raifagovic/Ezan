//
//  AppDelegate.swift
//  AdhanTime
//
//  Created by Raif Agovic on 25. 8. 2024..
//

import Cocoa
import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate {
    var settingsWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Add observer for wake notifications
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(macDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    @objc func macDidWake(notification: NSNotification) {
        StatusBarViewModel.shared.refresh()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Remove observers when the app is about to terminate
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    func openSettingsWindow() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
                .environmentObject(StatusBarViewModel.shared)
            
            let hostingController = NSHostingController(rootView: settingsView)
            settingsWindow = NSWindow(
                contentViewController: hostingController
            )
            settingsWindow.title = "Settings"
            settingsWindow.setContentSize(NSSize(width: 300, height: 300))
            settingsWindow.styleMask = [.titled, .closable, .resizable]
            settingsWindow.center()
        }
        
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
