//
//  NepaliDate.swift -  NepaliDate struct + extensions
//  aaza
//
//  Created by Prem Gautam on 8/2/2026.
//


import Foundation


struct NepaliDate: Equatable {
    let day: Int
    let month: Int
    let year: Int
    
    static let monthNames = [
           "बैशाख", "जेठ", "आषाढ", "श्रावण", "भाद्र", "आश्विन",
           "कार्तिक", "मंसिर", "पुष", "माघ", "फागुन", "चैत्र"
       ]
    
    static let monthNamesRomanized = [
        "Baisakh", "Jestha", "Ashadh", "Shrawan", "Bhadra", "Ashwin",
        "Kartik", "Mangsir", "Poush", "Magh", "Falgun", "Chaitra"
    ]
}

extension Int {
    func toNepaliDigits() -> String {
        let map: [Character: Character] = [
            "0": "०",
            "1": "१",
            "2": "२",
            "3": "३",
            "4": "४",
            "5": "५",
            "6": "६",
            "7": "७",
            "8": "८",
            "9": "९"
        ]
        return String(String(self).map { map[$0] ?? $0 })
    }
}

