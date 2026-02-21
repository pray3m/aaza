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
    
    @AppStorage("display.numberStyle") private var numberStyleRaw = NumberStyle.devanagari.rawValue
    @AppStorage("display.monthScript") private var monthScriptRaw = MonthScript.nepali.rawValue
    @AppStorage("display.formatStyle") private var formatStyleRaw = DateFormatStyle.long.rawValue
    
    private var numberStyle: NumberStyle {
        NumberStyle(rawValue: numberStyleRaw) ?? .devanagari
    }

    private var monthScript: MonthScript {
        MonthScript(rawValue: monthScriptRaw) ?? .nepali
    }

    private var formatStyle: DateFormatStyle {
        DateFormatStyle(rawValue: formatStyleRaw) ?? .long
    }
    
    private var displayPreferences: DisplayPreferences {
        DisplayPreferences(
            numberStyle: numberStyle,
            monthScript: monthScript,
            formatStyle: formatStyle
        )
    }
    
    private var formattedToday: String {
        guard let today = dateController.todayBS else { return "--" }
        return DateDisplayFormatter.format(today, preferences: displayPreferences)
    }



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
                    
                    Text(formattedToday)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                }
                
                if let errorText = dateController.appError?.errorDescription {
                    Text(errorText)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                // Action Buttons
                Button("Refresh") { dateController.refreshNow() }
                
                Button("Open Calendar") {
                    if let url = URL(string: "https://www.simplepatro.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                SettingsLink()
                
                Button("Quit App") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
        } label: {
            // THIS is what is visible on the TOP PANEL
            Text(formattedToday)
          
        }.menuBarExtraStyle(.menu)
    }

    
}
