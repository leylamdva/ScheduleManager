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
                HStack{
                    Spacer()
                    NavigationLink(destination: CreateTask(user: user, task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: []), isNewTask: true, start_time: selectedDate, end_time: selectedDate), label: {
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
