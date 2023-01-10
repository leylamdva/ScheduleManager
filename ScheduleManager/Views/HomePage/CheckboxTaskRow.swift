//
//  TaskRow.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/19/22.
//

import SwiftUI

struct CheckboxTaskRow: View {
    var task: UserTask
    @ObservedObject var user: User
    @State var isCompleted = false
    
    var body: some View {
        VStack {
            HStack{
                // Checkmark
                Button{
                    // If completed, notify database
                    Task {
                        await toggleComplete(taskId: task.id)
                    }
                    isCompleted.toggle()
                }label: {
                    Image(systemName: (task.isCompleted && isCompleted) ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                // Regular or crossed out text
                if task.isCompleted && isCompleted {
                    NavigationLink(destination: CreateTask(user: user, task: task, isNewTask: false), label: {
                        Text(task.name)
                            .font(.title3)
                            .strikethrough()
                    })
                    .buttonStyle(PlainButtonStyle())
                }else{
                    NavigationLink(destination: CreateTask(user: user, task: task, isNewTask: false), label: {
                        Text(task.name)
                            .font(.title3)
                    })
                    .buttonStyle(PlainButtonStyle())
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
        .onAppear(perform: {
            isCompleted = task.isCompleted
        })
    }
    
    func toggleComplete(taskId: String) async {
        let url = RequestBase().url + "/api/Tasks/toggleComplete" + taskId
        
        let body = Data()
        
        let (data, status) = await API().sendPostRequest(requestUrl: url, requestBodyComponents: body, token: user.token)
        print(String(decoding: data, as: UTF8.self))
        
        if status == 200 || status == 201 {
            print("Successfully toggled")
        } else{
            print("An error occurred")
        }
    }
}

struct TagsView: View {
    var tags: [Tag]
    var body: some View {
        ForEach(tags, id: \.self) { tag in
            Text(tag.name).bold()
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 7).fill(Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue)))
        }
    }
}

struct WeatherIcon: View {
    var weather: String
    
    var body: some View {
        switch weather{
        case "Clear":
            Image(systemName: "sun.max")
        case "Rainy":
            Image(systemName: "cloud.rain")
        case "Cloudy":
            Image(systemName: "cloud")
        case "Snow":
            Image(systemName: "cloud.snow")
        case "Foggy":
            Image(systemName: "cloud.fog")
        default:
            Image(systemName: "questionmark.app")
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxTaskRow(task: UserTask(id: "", name: "Tennis", isTimeSensitive: true, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "Clear", isCompleted: false, tags: [Tag(id: "", name: "sports", color: SelectedColor(red: 1, green: 0, blue: 0)), Tag(id: "", name: "Personal", color: SelectedColor(red: 1, green: 0, blue: 0))]), user: User())
            .preferredColorScheme(.dark)
    }
}

