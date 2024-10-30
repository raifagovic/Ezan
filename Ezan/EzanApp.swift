//
//  AdhanTimeApp.swift
//  AdhanTime
//
//  Created by Raif Agovic on 18. 3. 2024..
//

import SwiftUI

@main
struct EzanApp: App {
    @StateObject private var viewModel = StatusBarViewModel.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(appDelegate: appDelegate)
                .environmentObject(viewModel)
        } label: {
            HStack() {
                Image("StatusBarIcon")
                    .aspectRatio(contentMode: .fit)
                Text(viewModel.statusBarTitle)
                    .foregroundColor(.primary) 
            }
        }
        .menuBarExtraStyle(.window)
    }
}


