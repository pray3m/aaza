//
//  aazaApp.swift
//  aaza
//
//  Created by Prem Gautam on 7/2/2026.
//

import SwiftUI
import Combine

@main
struct AazaMenuBarUtility: App {
    @State private var todayBS: NepaliDate?
    @State private var errorText: String?
    
    private let ktmTimeZone = TimeZone(identifier: "Asia/Kathmandu")!
    private let refreshTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    

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
                    
                    Text(todayBS?.compactNepaliDigits ?? "--")
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                }
                
                if let errorText{
                    Text(errorText).font(.footnote).foregroundColor(.red)
                }
                
                // Action Buttons
                Button("Refresh") { refreshDate() }
                
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
            .onAppear(perform: refreshDate)
            .onReceive(refreshTimer){_ in refreshDateIfDayChanged()}
        } label: {
            // THIS is what is visible on the TOP PANEL
            HStack {
                Image(systemName: "calendar.badge.clock")
                Text(todayBS?.displayNepaliDigits ?? "...")
                    .fontWeight(.bold)
            }
        }.menuBarExtraStyle(.menu)
    }
    
    private func refreshDate(){
        do{
            todayBS = try NepaliDateConverter.todayNepaliDate(timeZone: ktmTimeZone)
            errorText = nil
        } catch {
            errorText = "Date out of supported range"
        }
    }
    
    private func refreshDateIfDayChanged(){
        let previous = todayBS
        refreshDate()
        if previous == todayBS { return}
    }
}
