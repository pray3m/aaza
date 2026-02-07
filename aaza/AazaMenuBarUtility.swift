//
//  aazaApp.swift
//  aaza
//
//  Created by Prem Gautam on 7/2/2026.
//

import SwiftUI

@main
struct AazaMenuBarUtility: App {
    @State private var barTitle:String = "🇳🇵 २६ माघ"

    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        
        MenuBarExtra{
            // Dropdown Content
            VStack(spacing:12) {
                VStack(spacing:4) {
                    Text("आज")
                        .font(.system(size: 12,weight: .medium,design: .default))
                        .foregroundColor(.secondary)
                    
                    Text("8/2/2083")
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
                // Action Buttons
                Button("Today's Date") {
                    print("fetching...")
                }

                Button("Settings") {
                    print("settings")
                }
                
                Button("Open Calendar") {
                    if let url = URL(string: "https://www.simplepatro.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("Quit App") {
                    NSApplication.shared.terminate(nil)
                }
            }
        } label: {
            // THIS is what is visible on the TOP PANEL
            HStack{
                Image(systemName: "calendar.badge.clock")
                Text(" २६ माघ, २०८२")
                    .fontWeight(.bold)
            }
        }.menuBarExtraStyle(.menu)
    }
}
