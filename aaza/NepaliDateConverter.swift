//
//  NepaliDateConverter.swift -  Gregorian ↔ Nepali conversion logic
//  aaza
//
//  Created by Prem Gautam on 8/2/2026.
//
import Foundation

enum NepaliDateError: LocalizedError {
    case invalidTimeZone(String)
    case anchorDateCreationFailed
    case unsupportedRange
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidTimeZone(let value):
            return "Invalid timezone: \(value)"
        case .anchorDateCreationFailed:
            return "Failed to build Gregorian anchor date"
        case .unsupportedRange:
            return "Date out of supported range (BS 2000-2090)"
        case .unknown(let message):
            return message
        }
    }
}

final class NepaliDateConverter {
    // Canonical anchor for this dataset:
    // 1943-04-14 AD == 2000-01-01 BS
    private static let baseBS = NepaliDate(day: 1, month: 1, year: 2000)

    private static func baseAD(in timeZone: TimeZone) throws -> Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone

        guard let anchor = cal.date(from: DateComponents(year: 1943, month: 4, day: 14)) else {
            throw NepaliDateError.anchorDateCreationFailed
        }

        return anchor
    }

    static func gregorianToNepali(
        _ date: Date,
        timeZone: TimeZone
    ) throws -> NepaliDate {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone

        let baseDay = cal.startOfDay(for: try baseAD(in: timeZone))
        let targetDay = cal.startOfDay(for: date)
        let dayDelta = cal.dateComponents([.day], from: baseDay, to: targetDay).day ?? 0

        guard let baseSerial = NepaliCalendar.serial(of: baseBS),
              let bs = NepaliCalendar.date(fromSerial: baseSerial + dayDelta) else {
            throw NepaliDateError.unsupportedRange
        }

        return bs
    }

    static func todayNepaliDate(
        timeZone: TimeZone? = nil
    ) throws -> NepaliDate {
        let resolvedTimeZone: TimeZone
        if let timeZone {
            resolvedTimeZone = timeZone
        } else if let kathmandu = TimeZone(identifier: "Asia/Kathmandu") {
            resolvedTimeZone = kathmandu
        } else {
            throw NepaliDateError.invalidTimeZone("Asia/Kathmandu")
        }

        return try gregorianToNepali(Date(), timeZone: resolvedTimeZone)
    }
}
