//
//  CalendarView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct CalendarView: View {
    @State private var date = Date()
    @State private var tasks = [
        Task(name: "Tennis", start_time: "09:00", end_time: "12:30", recurring: "true", weather: "sunny", tags: [Tag(name: "Sports", color: "yellow")]),
        Task(name: "Software Engineering Homework", start_time: "", end_time: "", recurring: "false", weather: "", tags: [Tag(name: "Homework", color: "red")])
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
                ForEach(tasks, id: \.self) { task in
                    //TODO: Destination to edit task
                    NavigationLink(destination: Text("Another view"), label: {NavTaskRow(task: task)})
                        .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                //Text("Picked date: \(date.formatted(date: .abbreviated, time: .omitted))")
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .preferredColorScheme(.dark)
    }
}
