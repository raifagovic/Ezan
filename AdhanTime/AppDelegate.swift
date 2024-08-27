//
//  AppDelegate.swift
//  AdhanTime
//
//  Created by Raif Agovic on 25. 8. 2024..
//

import Cocoa
import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate {
    
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
}
