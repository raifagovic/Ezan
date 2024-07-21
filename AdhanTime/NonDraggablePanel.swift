//
//  NonDraggablePanel.swift
//  AdhanTime
//
//  Created by Raif Agovic on 21. 7. 2024..
//

import Cocoa

class NonDraggablePanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        // Do nothing to disable dragging
    }
    
    override func mouseDragged(with event: NSEvent) {
        // Do nothing to disable dragging
    }
    
    override func mouseUp(with event: NSEvent) {
        // Do nothing to disable dragging
    }
}
