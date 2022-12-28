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
    
}
