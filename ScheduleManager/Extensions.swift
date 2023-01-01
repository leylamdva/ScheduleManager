//
//  Extensions.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/26/22.
//

import Foundation
import SwiftUI

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}

extension DateFormatter {
    static let times : DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    static let iso: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
}

extension Date{
    
    var hour : Int {
        let cal = Calendar.current
        return cal.dateComponents([.hour], from: self).hour ?? 0
    }
    
    var day : Int {
        let cal = Calendar.current
        return cal.dateComponents([.day], from: self).day ?? 0
    }
    
    var month : Int {
        let cal = Calendar.current
        return cal.dateComponents([.month], from: self).month ?? 0
    }
    
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func roundUp() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        if minute != 0 {
            components.minute =  60 - minute
        }
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func roundDown() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        if minute != 0 {
            components.minute = -minute
        }
        return Calendar.current.date(byAdding: components, to: self)
    }
}
