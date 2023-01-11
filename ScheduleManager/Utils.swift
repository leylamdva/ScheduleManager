//
//  Utils.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import Foundation

func convertTemperature(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> Double {
    let input = Measurement(value: temp, unit: inputTempType)
    let output = input.converted(to: outputTempType)
    return output.value
}

func setStartAndEndTime(tasks: [UserTask], start_time: Date, end_time: Date) -> (Date, Date) {
    
    var new_start_time = start_time
    var new_end_time = end_time
    
    for task in tasks{
        //print(task.startDateTime)
        let taskStartDateTime = DateFormatter.iso.date(from: task.startDateTime) ?? Date.now
        if taskStartDateTime != Date.now && taskStartDateTime < new_start_time {
            new_start_time = DateFormatter.iso.date(from: task.startDateTime)!
            new_start_time = new_start_time.roundDown()!
        }
        
        //print(task.endDateTime)
        let taskEndDateTime = DateFormatter.iso.date(from: task.endDateTime) ?? Date.now
        if taskEndDateTime != Date.now && taskEndDateTime > new_end_time {
            new_end_time = DateFormatter.iso.date(from: task.endDateTime)!
            new_end_time = new_end_time.roundUp()!
        }
        
        
    } //for loop
    
    return (new_start_time, new_end_time)
}

func setDays(option: String) -> [Bool] {
    var selectedDays = [false, false, false, false, false, false, false]
    switch(option) {
    case "Everyday":
        selectedDays = [true, true, true, true, true, true, true]
    case "Weekends":
        selectedDays = [false, false, false, false, false, true, true]
    case "Weekdays":
        selectedDays = [true, true, true, true, true, false, false]
    default:
        return selectedDays
    }
    
    return selectedDays
}
