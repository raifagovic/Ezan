//
//  AppDelegate.swift
//  AdhanTime
//
//  Created by Raif Agovic on 3. 6. 2024..
//


import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController.shared
        
        // Create the main application window
        let contentView = ContentView()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false // Ensure the window is not released
        
        // Keep a reference to the window
        self.window = window
        
        // Set the main window reference in StatusBarController
        statusBarController?.setMainWindow(window)
        
        // Add observer for wake notifications
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(macDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    @objc func macDidWake(notification: NSNotification) {
        statusBarController?.refresh()
        NotificationCenter.default.post(name: Notification.Name("MacDidWake"), object: nil)
    }
}

