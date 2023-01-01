//
//  TaskRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import SwiftUI

struct CheckboxTaskRow: View {
    var task: UserTask
    @State var isCompleted: Bool = false
    var body: some View {
        VStack {
            HStack{
                // Checkmark
                Button{
                    // TODO: update the database when the task is completed
                    isCompleted.toggle()
                }label: {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                // Regular or crossed out text
                if isCompleted{
                    Text(task.name)
                        .font(.title3)
                        .strikethrough()
                }else{
                    Text(task.name)
                        .font(.title3)
                }
                Spacer()
                // Weather icon
                if task.weatherRequirement != "None" {
                    WeatherIcon(weather: task.weatherRequirement)
                }
                // Tags
                if !task.tags.isEmpty{
                    TagsView(tags: task.tags)
                }
            }
            .padding(5)
            Divider()
        } //VStack
    }
}

struct TagsView: View {
    var tags: [Tag]
    var body: some View {
        ForEach(tags, id: \.self) { tag in
            // TODO: Fix Color to be color of tags
            Text(tag.name).bold()
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 7).fill(.yellow))
        }
    }
}

struct WeatherIcon: View {
    var weather: String
    var body: some View {
        // TODO: Change cases according to database entries
        switch weather{
        case "sunny":
            Image(systemName: "sun.max")
        case "rainy":
            Image(systemName: "cloud.rain")
        case "cloudy":
            Image(systemName: "cloud")
        default:
            Image(systemName: "questionmark.app")
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxTaskRow(task: UserTask(name: "Tennis", isTimeSensitive: true, startDateTime: Date.now, endDateTime: Date.now, repeatDays: [], weatherRequirement: "sunny", isCompleted: false, tags: [Tag(name: "sports", color: SelectedColor(red: 1, green: 0, blue: 0)), Tag(name: "Personal", color: SelectedColor(red: 1, green: 0, blue: 0))]))
            .preferredColorScheme(.dark)
    }
}

