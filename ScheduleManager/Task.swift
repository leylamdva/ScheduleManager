//
//  Task.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import Foundation

struct Task: Hashable {
    var name: String;
    var start_time: String;
    var end_time: String;
    var recurring: String;
    var weather: String;
    var tags: [Tag];
}

struct Tag: Hashable {
    var name: String;
    var color: String;
}
