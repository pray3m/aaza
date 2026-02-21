//
//  DateDisplayFormatter.swift
//  aaza
//
//  Created by Prem Gautam on 22/2/2026.
//

enum NumberStyle: String, CaseIterable {
    case devanagari
    case english
}

enum MonthScript: String, CaseIterable{
    case nepali
    case romanized
}

enum DateFormatStyle: String, CaseIterable {
    case long
    case compact
}

struct DisplayPreferences: Equatable {
    let numberStyle: NumberStyle
    let monthScript: MonthScript
    let formatStyle: DateFormatStyle
}

enum DateDisplayFormatter{
    
    static func format (_ date: NepaliDate, preferences: DisplayPreferences)-> String {
        let day = styledNumber(date.day, style: preferences.numberStyle)
        let year = styledNumber(date.year, style: preferences.numberStyle)

        switch preferences.formatStyle {
          case .long:
            let monthName = monthName(for: date.month, script: preferences.monthScript)
            return "\(day) \(monthName), \(year)"
          case .compact:
            let monthNumber = styledNumber(date.month, style: preferences.numberStyle)
            return "\(day)/\(monthNumber)/\(year)"
          }
    }
    
   
    
    private static func styledNumber(_ value:Int, style: NumberStyle) -> String {
        switch style {
        case .devanagari:
            return value.toNepaliDigits()
        case .english:
            return String(value)
        }
    }
    
    private static func monthName(for month: Int, script: MonthScript) -> String {
        guard (1...12).contains(month) else { return "invalid" }
        switch script{
        case .nepali:
            return NepaliDate.monthNames[month-1]
        case .romanized:
            return NepaliDate.monthNamesRomanized[month-1]
        }
    }
    
}
