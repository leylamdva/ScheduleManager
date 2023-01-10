//
//  CalendarView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var user: User
    @State private var selectedDate = Date()
    @ObservedObject var tasksViewModel = TasksViewModel()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .onChange(of: selectedDate, perform: { newValue in
                        Task {
                            await tasksViewModel.sendQuery(date: DateFormatter.iso8601.string(from: selectedDate), token: user.token)
                        }
                    })
                Divider()
                //Title
                Text("Tasks")
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding(.horizontal, 20)
                // Tasks
                if tasksViewModel.tasks.isEmpty {
                    Text("No tasks available for the selected day")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding()
                } else{
                    ScrollView {
                        ForEach(tasksViewModel.tasks, id: \.self) { task in
                            NavTaskRow(task: task, user: user)
                        }
                    }
                }
                Spacer()
                // Plus icon (For adding tasks)
                AddTaskButtonView(user: user, startTime: selectedDate, endTime: selectedDate)
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .task {
            await tasksViewModel.sendQuery(date: DateFormatter.iso8601.string(from: selectedDate), token: user.token)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(user: User())
            .preferredColorScheme(.dark)
    }
}
