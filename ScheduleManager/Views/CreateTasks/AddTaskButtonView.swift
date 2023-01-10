//
//  AddTaskButtonView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct AddTaskButtonView: View {
    var user: User
    var startTime: Date = Date.now
    var endTime: Date = Date.now
    
    var body: some View {
        HStack{
            Spacer()
            NavigationLink(destination: CreateTask(user: user, task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: []), isNewTask: true, start_time: startTime, end_time: endTime), label: {
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
    }
}

struct AddTaskButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskButtonView(user: User())
            .preferredColorScheme(.dark)
    }
}
