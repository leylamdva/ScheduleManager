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
        Task(name: "Tennis", start_time: "09:00", end_time: "12:30", weather: "sunny", tags: [Tag(name: "Sports", color: "yellow")]),
        Task(name: "Software Engineering Homework", start_time: "", end_time: "", weather: "", tags: [Tag(name: "Homework", color: "red")])
    ]
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            Divider()
            // Tasks Checklist
            ForEach(tasks, id: \.self) { task in
                CheckboxTaskRow(task: task)
            }
            Spacer()
            //Text("Picked date: \(date.formatted(date: .abbreviated, time: .omitted))")
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
