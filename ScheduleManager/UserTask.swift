//
//  Task.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import Foundation

struct UserTask: Hashable {
    var name: String
    var timeSensitive: Bool
    var start_time: Date
    var end_time: Date
    var recurring: String
    var weather: String
    var tags: [Tag]
}

struct Tag: Hashable {
    var name: String
    var color: SelectedColor
}

struct SelectedColor: Hashable {
    var red: Double
    var green: Double
    var blue: Double
}
