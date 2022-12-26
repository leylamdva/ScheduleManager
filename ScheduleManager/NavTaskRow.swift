//
//  NavTaskRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import SwiftUI

struct NavTaskRow: View {
    var task: Task
    var body: some View {
        HStack{
            //Name of task
            Text(task.name)
            Spacer()
            // Weather icon
            if task.weather != "" {
                WeatherIcon(weather: task.weather)
            }
            // Time sensitive
            if task.start_time != ""{
                Image(systemName: "clock")
            }
            //Recurring
            if task.recurring == "true"{
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
        NavTaskRow(task: Task(name: "Tennis", start_time: "9AM", end_time: "12PM", recurring: "true", weather: "sunny", tags: [Tag(name: "sports", color: SelectedColor(red: 1, green: 0, blue: 0))]))
            .preferredColorScheme(.dark)
    }
}
