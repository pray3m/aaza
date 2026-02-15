//
//  aazaApp.swift
//  aaza
//
//  Created by Prem Gautam on 7/2/2026.
//

import SwiftUI

@main
struct AazaMenuBarUtility: App {
    @State private var todayBS: NepaliDate?
    @State private var appError: NepaliDateError?
    @State private var midnightRefreshTimer: Timer?
    @State private var didInitialize = false

    private let ktmTimeZone = TimeZone(identifier: "Asia/Kathmandu")

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
                
                if let errorText = appError?.errorDescription {
                    Text(errorText)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
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
            .onAppear {
                guard !didInitialize else { return }
                didInitialize = true
                refreshDate()
                scheduleNextMidnightRefresh()
            }
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
        guard let ktmTimeZone else {
            appError = .invalidTimeZone("Asia/Kathmandu")
            return
        }

        do{
            todayBS = try NepaliDateConverter.todayNepaliDate(timeZone: ktmTimeZone)
            appError = nil
        } catch let error as NepaliDateError {
            appError = error
        } catch {
            appError = .unknown(error.localizedDescription)
        }
    }

    private func refreshDateIfDayChanged() {
        let previous = todayBS
        refreshDate()
        if previous != todayBS {
            // Day changed in Kathmandu timezone; state has already updated.
        }
        scheduleNextMidnightRefresh()
    }

    private func scheduleNextMidnightRefresh() {
        midnightRefreshTimer?.invalidate()

        guard let ktmTimeZone else {
            appError = .invalidTimeZone("Asia/Kathmandu")
            return
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = ktmTimeZone

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        guard let nextMidnight = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
            appError = .unknown("Failed to calculate next Kathmandu midnight")
            return
        }

        let interval = max(1, nextMidnight.timeIntervalSince(now) + 1)
        midnightRefreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            refreshDateIfDayChanged()
        }
    }
}
