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
final class MenuBarDateController: ObservableObject {
    @Published var todayBS: NepaliDate?
    @Published var appError: NepaliDateError?
    
    private let nepaliTimeZone = TimeZone(identifier: "Asia/Kathmandu")
    private var midnightRefreshTimer: Timer?
    private var observers: [NSObjectProtocol] = []
    
    init() {
        refreshDate()
        scheduleNextMidnightRefresh()
        installObservers()
    }
    
    deinit {
        midnightRefreshTimer?.invalidate()
        observers.forEach(NotificationCenter.default.removeObserver)
    }
    
    
    func refreshDate() {
        guard let nepaliTimeZone else {
            appError = .invalidTimeZone("Asia/Kathmandu")
            return
        }
        do {
            todayBS = try NepaliDateConverter.todayNepaliDate(timeZone: nepaliTimeZone)
            appError = nil
        } catch let error as NepaliDateError {
            appError = error
        } catch {
            appError = .unknown(error.localizedDescription)
        }
    }

    func refreshNow() {
        refreshAndReschedule()
    }
    
    private func refreshAndReschedule() {
        refreshDate()
        scheduleNextMidnightRefresh()
    }

    private nonisolated static func enqueueRefresh(for controller: MenuBarDateController?) {
        guard let controller else { return }
        Task { @MainActor in
            controller.refreshAndReschedule()
        }
    }

    private func observe(_ name: Notification.Name, center: NotificationCenter, queue: OperationQueue) {
        observers.append(
            center.addObserver(forName: name, object: nil, queue: queue) { [weak self] _ in
                Self.enqueueRefresh(for: self)
            }
        )
    }
    
    private func installObservers() {
        let center = NotificationCenter.default
        let queue = OperationQueue.main

        observe(.NSCalendarDayChanged, center: center, queue: queue)
        observe(NSNotification.Name.NSSystemClockDidChange, center: center, queue: queue)
        observe(NSNotification.Name.NSSystemTimeZoneDidChange, center: center, queue: queue)
        observe(NSWorkspace.didWakeNotification, center: center, queue: queue)
    }
    
    private func scheduleNextMidnightRefresh() {
        midnightRefreshTimer?.invalidate()
        
        var calendar = Calendar(identifier: .gregorian)
        guard let nepaliTimeZone else {
            appError = .invalidTimeZone("Asia/Kathmandu")
            return
        }
        calendar.timeZone = nepaliTimeZone
        
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        guard let nextMidnight = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
            appError = .unknown("Failed to calculate next midnight")
            return
        }
        
        let interval = max(1, nextMidnight.timeIntervalSince(now) + 1)
        let timer = Timer(timeInterval: interval, repeats: false) { [weak self] _ in
            Self.enqueueRefresh(for: self)
        }
        timer.tolerance = 1
        RunLoop.main.add(timer, forMode: .common)
        midnightRefreshTimer = timer
    }
}
