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
        Task(name: "Tennis", start_time: "09:00", end_time: "12:30", recurring: "true", weather: "sunny", tags: [Tag(name: "Sports", color: SelectedColor(red: 1, green: 0, blue: 0))]),
        Task(name: "Software Engineering Homework", start_time: "", end_time: "", recurring: "false", weather: "", tags: [Tag(name: "Homework", color: SelectedColor(red: 1, green: 0, blue: 0))])
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
                    NavigationLink(destination: CreateTask(), label: {
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
        CalendarView()
            .preferredColorScheme(.dark)
    }
}
