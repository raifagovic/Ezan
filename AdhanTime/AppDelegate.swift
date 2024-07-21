//
//  AppDelegate.swift
//  AdhanTime
//
//  Created by Raif Agovic on 3. 6. 2024..
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
        NotificationCenter.default.post(name: Notification.Name("MacDidWake"), object: nil)
    }
}

