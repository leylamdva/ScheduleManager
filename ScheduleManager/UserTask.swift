//
//  Task.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import Foundation

struct UserTask: Hashable, Codable {
    var id: String
    var name: String
    var isTimeSensitive: Bool
    var startDateTime: String
    var endDateTime: String
    var repeatDays: [Bool]
    var weatherRequirement: String
    var isCompleted: Bool
    var tags: [Tag]
}

struct Tag: Hashable, Codable {
    var id: String
    var name: String
    var color: SelectedColor
}

struct SelectedColor: Hashable, Codable {
    var red: Double
    var green: Double
    var blue: Double
}
