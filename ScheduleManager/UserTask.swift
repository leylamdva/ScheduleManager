//
//  Task.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import Foundation

struct UserTask: Hashable {
    var name: String
    var isTimeSensitive: Bool
    var startDateTime: Date
    var endDateTime: Date
    var repeatDays: [Bool]
    var weatherRequirement: String
    var isCompleted: Bool
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
