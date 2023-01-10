//
//  TaskChecklist.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TaskChecklist: View {
    var tasks: [UserTask]
    var user: User
    
    @State var showDropDown = false
    @State var selectedTag = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("Other")
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
                Button(action: {
                    showDropDown.toggle()
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filter")
                        .font(.title2)
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
            }
            
            // List of tags
            if showDropDown {
                HStack {
                    Spacer()
                    VStack {
                        ForEach(tasks, id: \.self) { task in
                            if !task.isTimeSensitive {
                                TagsButtonView(tags: task.tags, selectedTag: $selectedTag)
                            }
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.gray))
                }
            }
            
            // List of tasks
            ForEach(tasks, id: \.self) { task in
                if !task.isTimeSensitive && selectedTag == "" {
                    CheckboxTaskRow(task: task, user: user)
                } else {
                    ForEach(task.tags, id: \.self) { tag in
                        if selectedTag == tag.name {
                            CheckboxTaskRow(task: task, user: user)
                        }
                    }
                }
            }
        } // VStack
    }
}

struct TaskChecklist_Previews: PreviewProvider {
    static var previews: some View {
        TaskChecklist(tasks: [], user: User())
            .preferredColorScheme(.dark)
    }
}
