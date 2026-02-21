//
//  aazaApp.swift
//  aaza
//
//  Created by Prem Gautam on 7/2/2026.
//

import SwiftUI

@main
struct AazaMenuBarUtility: App {
    @StateObject private var dateController = MenuBarDateController()

    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        
        MenuBarExtra{
            // Dropdown Content
            VStack(spacing:12) {
                VStack(spacing:4) {
                    Text("आज ")
                        .font(.system(size: 12,weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(dateController.todayBS?.compactNepaliDigits ?? "--")
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                }
                
                if let errorText = dateController.appError?.errorDescription {
                    Text(errorText)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                // Action Buttons
                Button("Refresh") { dateController.refreshDate() }
                
                Button("Open Calendar") {
                    if let url = URL(string: "https://www.simplepatro.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("Settings") {
                    print("settings")
                }
                
                Button("Quit App") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
        } label: {
            // THIS is what is visible on the TOP PANEL
            HStack {
                Text(dateController.todayBS?.displayNepaliDigits ?? "--")
                    .fontWeight(.bold)
            }
        }.menuBarExtraStyle(.menu)
    }

    
}
