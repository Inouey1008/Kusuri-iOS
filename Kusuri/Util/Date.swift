//
//  Date.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/01.
//

import Foundation

extension Date {
    static var zero: Date {
        return Date(timeIntervalSinceReferenceDate: 0)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = Calendar.current
        var component = DateComponents()

        component.year = year ?? calendar.component(.year, from: self)
        component.month = month ?? calendar.component(.month, from: self)
        component.day = day ?? calendar.component(.day, from: self)
        component.hour = hour ?? calendar.component(.hour, from: self)
        component.minute = minute ?? calendar.component(.minute, from: self)
        component.second = second ?? calendar.component(.second, from: self)

        return calendar.date(from: component)!
    }

    static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let calendar = Calendar.current
        var component = DateComponents()

        component.year = year
        component.month = month
        component.day = day
        component.hour = hour
        component.minute = minute
        component.second = second

        return calendar.date(from: component)!
    }

    static func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
