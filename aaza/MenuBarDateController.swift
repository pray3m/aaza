//
//  MenuBarDateController.swift
//  aaza
//
//  Created by Prem Gautam on 21/2/2026.
//

import Combine
import Foundation
import AppKit

@MainActor
final class MenuBarDateController: ObservableObject{
    @Published var todayBS: NepaliDate?
    @Published var appError: NepaliDateError?
    
    private let ktmTimeZone = TimeZone(identifier: "Asia/Kathmandu")
    private var midnightRefreshTimer: Timer?
    private var observers: [NSObjectProtocol] = []
    
    init(){
        refreshDate()
        scheduleNextMidnightRefresh()
        installObservers()
    }
    
    deinit {
        midnightRefreshTimer?.invalidate()
        observers.forEach(NotificationCenter.default.removeObserver)
    }
    
    
    func refreshDate(){
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
    
    private func refreshAndReschedule(){
        refreshDate()
        scheduleNextMidnightRefresh()
    }
    
    private func installObservers() {
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        observers.append(center.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: queue) {
            [weak self] _ in guard let self else {return}
            Task{
                @MainActor [self] in self.refreshAndReschedule()
            }
        })
        
        observers.append(center.addObserver(forName: NSNotification.Name.NSSystemClockDidChange, object: nil, queue: queue) {
            [weak self] _ in guard let self else {return}
            Task {
                @MainActor [self] in self.refreshAndReschedule()
            }
        })

        observers.append(center.addObserver(forName: NSNotification.Name.NSSystemTimeZoneDidChange, object: nil, queue: queue) {
            [weak self] _ in guard let self else {return}
            Task {
                @MainActor [self] in self.refreshAndReschedule()
            }
        })

        observers.append(center.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: queue) { [weak self] _ in guard let self else {return}
            Task {
                @MainActor [self] in self.refreshAndReschedule()
            }
        })
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
        let timer = Timer(timeInterval: interval, repeats:false) {
            [weak self] _ in guard let self else {return}
            Task{
                @MainActor [self] in self.refreshAndReschedule()
            }
        }
        timer.tolerance = 1
        RunLoop.main.add(timer, forMode: .common)
        midnightRefreshTimer = timer
    }
}
