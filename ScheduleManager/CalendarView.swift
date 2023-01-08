//
//  CalendarView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var user: User
    @State private var date = Date()
    @State private var tasks = [
        UserTask(id: "", name: "Tennis", isTimeSensitive: true, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "sunny", isCompleted: false, tags: [Tag(id: "", name: "Sports", color: SelectedColor(red: 1, green: 0, blue: 0))]),
        UserTask(id: "", name: "Software Engineering Homework", isTimeSensitive: true, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "", isCompleted: false, tags: [Tag(id: "", name: "Homework", color: SelectedColor(red: 1, green: 0, blue: 0))])
    ]
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                Divider()
                //Title
                Text("Tasks")
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding(.horizontal, 20)
                // Tasks
                ScrollView {
                    ForEach(tasks, id: \.self) { task in
                        //TODO: Destination to edit task
                        NavigationLink(destination: Text("Another view"), label: {NavTaskRow(task: task)})
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                Spacer()
                // Plus icon (For adding tasks)
                HStack{
                    Spacer()
                    NavigationLink(destination: CreateTask(user: user, task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: [])), label: {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 65, height: 65)
                                .padding()
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                //Text("Picked date: \(date.formatted(date: .abbreviated, time: .omitted))")
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(user: User())
            .preferredColorScheme(.dark)
    }
}
