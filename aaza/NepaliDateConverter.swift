//
//  NepaliDateConverter.swift -  Gregorian ↔ Nepali conversion logic
//  aaza
//
//  Created by Prem Gautam on 8/2/2026.
//
import Foundation

enum NepaliDateConversionError: Error {
    case unsupportedRange
}

final class NepaliDateConverter {
    // Canonical anchor for this dataset:
    // 1943-04-14 AD == 2000-01-01 BS
    private static let baseBS = NepaliDate(day: 1, month: 1, year: 2000)
    
    private static var baseAD: Date {
           var cal = Calendar(identifier: .gregorian)
           cal.timeZone = TimeZone(identifier: "Asia/Kathmandu")!
           return cal.date(from: DateComponents(year: 1943, month: 4, day: 14))!
    }
    
    static func gregorianToNepali( _ date: Date, timeZone: TimeZone = TimeZone(identifier: "Asia/Kathmandu")!) throws -> NepaliDate {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        
        
        let baseDay = cal.startOfDay(for: baseAD)
        let targetDay = cal.startOfDay(for: date)
        let dayDelta = cal.dateComponents([.day], from: baseDay, to: targetDay).day ?? 0
        
        guard let baseSerial = NepaliCalendar.serial(of: baseBS),
                      let bs = NepaliCalendar.date(fromSerial: baseSerial + dayDelta) else {
                    throw NepaliDateConversionError.unsupportedRange }
        
        
        return bs
    }
    
    static func todayNepaliDate(
           timeZone: TimeZone = TimeZone(identifier: "Asia/Kathmandu")!
       ) throws -> NepaliDate {
           try gregorianToNepali(Date(), timeZone: timeZone)
       }
}
