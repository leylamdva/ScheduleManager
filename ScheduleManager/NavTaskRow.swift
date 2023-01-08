//
//  NavTaskRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import SwiftUI

struct NavTaskRow: View {
    var task: UserTask
    var body: some View {
        HStack{
            //Name of task
            Text(task.name)
            Spacer()
            // Weather icon
            if task.weatherRequirement != "" {
                WeatherIcon(weather: task.weatherRequirement)
            }
            // Time sensitive
            //TODO: fix time check
            if task.isTimeSensitive {
                Image(systemName: "clock")
            }
            //Recurring
            if !task.repeatDays.isEmpty && task.repeatDays.contains(true){
                Image(systemName: "repeat")
            }
            // Custom tags
            if !task.tags.isEmpty {
                TagsView(tags: task.tags)
            }
            //Right arrow (for nav link)
            Image(systemName: "chevron.right")
        }
        .padding(10)
        .padding(.horizontal, 20)
    }
}

struct NavTaskRow_Previews: PreviewProvider {
    static var previews: some View {
        NavTaskRow(task: UserTask(id: "", name: "Tennis", isTimeSensitive: true, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "sunny", isCompleted: false, tags: [Tag(id: "", name: "sports", color: SelectedColor(red: 1, green: 0, blue: 0))]))
            .preferredColorScheme(.dark)
    }
}
