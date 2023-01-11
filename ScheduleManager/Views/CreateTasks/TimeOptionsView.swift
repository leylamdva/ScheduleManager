//
//  TimeOptionsView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TimeOptionsView: View {
    @Binding var task: UserTask
    @Binding var start_time: Date
    @Binding var end_time: Date
    var fieldColor: Color
    
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Text("Time-Sensitive")
                    .modifier(MenuText())
                Toggle("", isOn: $task.isTimeSensitive)
            }
            .padding(.horizontal, 20)
            
            DividerView()
            
            // Start Time
            HStack {
                if task.isTimeSensitive{
                    Text("Start Time")
                        .modifier(MenuText())
                    DatePicker("", selection: $start_time)
                } else{
                    DisabledOptionView(title: "Start Time")
                }
            }
            .padding(.horizontal, 20)
            
            DividerView()
            
            // End Time
            HStack {
                if task.isTimeSensitive{
                    Text("End Time")
                        .modifier(MenuText())
                    DatePicker("", selection: $end_time)
                } else{
                    DisabledOptionView(title: "End Time")
                }
                
            } //HStack
            .padding(.horizontal, 20)
        } // Time VStack
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(fieldColor))
    }
}

struct TimeOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeOptionsView(task: .constant(UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: [], duration: 0, hourOffset: 0)), start_time: .constant(Date.now), end_time: .constant(Date.now), fieldColor: .gray)
            .preferredColorScheme(.dark)
    }
}
