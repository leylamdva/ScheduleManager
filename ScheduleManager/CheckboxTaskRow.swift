//
//  TaskRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import SwiftUI

struct CheckboxTaskRow: View {
    var task: Task
    @State var isCompleted: Bool = false
    var body: some View {
        VStack {
            HStack{
                // Checkmark
                Button{
                    isCompleted.toggle()
                }label: {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                // Regular or crossed out text
                if isCompleted{
                    Text(task.name)
                        .strikethrough()
                }else{
                    Text(task.name)
                }
                Spacer()
                // Weather icon
                if task.weather != "" {
                    WeatherIcon(weather: task.weather)
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
        CheckboxTaskRow(task: Task(name: "Tennis", start_time: "9AM", end_time: "12PM", recurring: "true", weather: "sunny", tags: [Tag(name: "sports", color: SelectedColor(red: 1, green: 0, blue: 0)), Tag(name: "Personal", color: SelectedColor(red: 1, green: 0, blue: 0))]))
            .preferredColorScheme(.dark)
    }
}

