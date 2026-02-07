//
//  aazaApp.swift
//  aaza
//
//  Created by Prem Gautam on 7/2/2026.
//

import SwiftUI

@main
struct AazaMenuBarUtility: App {
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        
        MenuBarExtra("Aaza", systemImage: "bolt.fill"){
            Button("Today's Date") {
                print("fetching...")
            }
            Divider()
            Button("Settings") {
                print("settings")
            }
            Divider()
            Button("Quit App") {
                NSApplication.shared.terminate(nil)
            }
        }.menuBarExtraStyle(.menu)
    }
}
