//
//  CreateTask.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/22/22.
//

import SwiftUI

struct CreateTask: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    let repeatTimes = ["Never", "Everyday", "Weekdays", "Weekends", "Custom"]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let weather = ["None", "Clear", "Rain", "Cloudy", "Snow", "Foggy"]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var user: User
    @State var task: UserTask
    @State var isNewTask: Bool
    
    @State var repeatTime = "Never"
    @State var selectedDays = [false, false, false, false, false, false, false]
    @State var start_time: Date = Date.now
    @State var end_time: Date = Date.now
    @State private var showAlert = false
    @State private var showError = false
    @State private var processing = false
    @State var addedTags: [String] = []
    @State var changedTags = false
    
    // Custom cancel button
    var buttonCancel: some View {Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
            Text("Back")
        }
    }
    
    // Custom done button
    var buttonDone: some View {Button(action: {
        if isNewTask {
            processing = true
            Task {
                await addTask()
                
                if !addedTags.isEmpty {
                    await syncTags()
                }
            }
        } else {
            processing = true
            Task {
                await updateTask()
            }
        }
    }) {
        Text("Done")
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack(alignment: .leading) {
                    TextField("Name", text: $task.name)
                        .modifier(InputField(fieldColor: fieldColor))
                        .padding(.vertical, 10)
                    
                    //Time options
                    TimeOptionsView(task: $task, start_time: $start_time, end_time: $end_time, fieldColor: fieldColor)
                    
                    // Repeat
                    RepeatView(repeatTime: $repeatTime, selectedDays: $selectedDays, repeatTimes: repeatTimes, fieldColor: fieldColor, days: days)
                    
                    // Tags Navigation View
                    NavigationLink(destination: CreateTagsView(task: $task, addedTags: $addedTags, changedTags: $changedTags, token: user.token), label: {
                        HStack {
                            Text("Tags")
                                .modifier(MenuText())
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .modifier(FieldBackgroundView(fieldColor: fieldColor))
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    // Weather
                    HStack {
                        Text("Weather")
                            .modifier(MenuText())
                        Spacer()
                        Picker("", selection: $task.weatherRequirement){
                            ForEach(weather, id: \.self){
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.white)
                    } // HStack Weather
                    .modifier(FieldBackgroundView(fieldColor: fieldColor))
                    
                    Spacer()
                    
                    if !isNewTask {
                        HStack {
                            Spacer()
                            Button(action: {
                                Task {
                                    await deleteTask(token: user.token, id: task.id)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }, label: {
                                Text("Delete Task")
                                    .font(.title3)
                                    .foregroundColor(.red)
                                    .underline()
                            })
                            Spacer()
                        }
                    }
                    
                }//VStack
                
                if processing {
                    ProgressView()
                        .frame(width:250, height: 250)
                }
            } //ZStack

        }
        .padding(.horizontal, 15)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Create a Task")
        .navigationBarItems(leading: buttonCancel, trailing: buttonDone)
        .onAppear(perform: {
            // If tags exist, add them to the array
            if !isNewTask && !changedTags{
                addedTags = []
                for tag in task.tags {
                    addedTags.append(tag.id)
                }
            }
            
            if !isNewTask {
                let taskStartTime = ($task).startDateTime
                let taskEndTime = ($task).endDateTime
                start_time = DateFormatter.iso.date(from: taskStartTime.wrappedValue) ?? Date.now
                end_time = DateFormatter.iso.date(from: taskEndTime.wrappedValue) ?? Date.now
            }
        })
        .alert("Success", isPresented: $showAlert){
            Button("Done", role: .cancel){ self.presentationMode.wrappedValue.dismiss() }
        } message: {
            Text("The task has been successfully added/edited")
        }
        .alert("Error", isPresented: $showError) {
            Button("Ok", role: .cancel){}
        } message: {
            Text("An error occurred while creating the task")
        }
    }
    
    func addTask() async {
        let url = RequestBase().url + "/api/Tasks"
        
        // Prepare array of days for posting request
        if repeatTime != "Custom" {
            selectedDays = setDays(option: repeatTime)
        }
        
        if task.name == "" {
            task.name = "Unnamed Task"
        }
        
        //print(DateFormatter.iso8601.string(from: start_time))
        let bodyObject : [String: Any] = [
            "name" : task.name,
            "isTimeSensitive" : task.isTimeSensitive,
            "startDateTime" : DateFormatter.iso8601.string(from: start_time),
            "endDateTime" : DateFormatter.iso8601.string(from: end_time),
            "repeatDays" : selectedDays,
            "weatherRequirement" : task.weatherRequirement,
            "tags" : []
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: bodyObject)
            
        let (data, status) = await API().sendPostRequest(requestUrl: url, requestBodyComponents: body, token: user.token)
            print(String(decoding: data, as: UTF8.self))
            
        do {
            if status == 200 || status == 201{
                if addedTags.isEmpty {
                    processing = false
                    showAlert = true
                }
                task = try JSONDecoder().decode(UserTask.self, from: data)
            }else{
                let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
                print(decodedMessage)
                processing = false
                showError = true
            }
        } catch {
            print(error)
        }
    }
    
    func syncTags() async {
        let url = RequestBase().url + "/api/Tasks/tags/" + task.id
        
        let bodyObject : [String: Any] = [
            "tags" : addedTags
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: bodyObject)
        print(String(decoding: body, as: UTF8.self))
        
        let (data, status) = await API().sendPutRequest(requestUrl: url, requestBodyComponents: body, token: user.token)
        print(String(decoding: data, as: UTF8.self))
        
        do {
            if status == 200 || status == 201{
                processing = false
                showAlert = true
            }else{
                let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
                print(decodedMessage)
                processing = false
                showError = true
            }
        } catch {
            print(error)
        }
    }
    
    func updateTask() async {
        let url = RequestBase().url + "/api/Tasks/" + task.id
        
        // Prepare array of days for posting request
        if repeatTime != "Custom" {
            selectedDays = setDays(option: repeatTime)
        }
        
        if task.name == "" {
            task.name = "Unnamed Task"
        }
        
        //print(DateFormatter.iso8601.string(from: start_time))
        //print(addedTags)
        let bodyObject : [String: Any] = [
            "name" : task.name,
            "isTimeSensitive" : task.isTimeSensitive,
            "startDateTime" : DateFormatter.iso8601.string(from: start_time),
            "endDateTime" : DateFormatter.iso8601.string(from: end_time),
            "repeatDays" : selectedDays,
            "weatherRequirement" : task.weatherRequirement,
            "isCompleted" : task.isCompleted,
            "tags" : addedTags
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: bodyObject)
            
        let (data, status) = await API().sendPutRequest(requestUrl: url, requestBodyComponents: body, token: user.token)
        print(String(decoding: data, as: UTF8.self))
            
        do {
            if status == 200 || status == 201{
                processing = false
                showAlert = true
            }else{
                let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
                print(decodedMessage)
                processing = false
                showError = true
            }
        } catch {
            print(error)
        }
    }
}

func deleteTask(token: String, id: String) async {
    let url = RequestBase().url + "/api/Tasks/" + id
    
    let body = Data()
    
    let (data, status) = await API().sendDeleteRequest(requestUrl: url, requestBodyComponents: body, token: token)
    print(String(decoding: data, as: UTF8.self))
    
    if status == 200 {
        print("Successfully deleted the task")
    } else {
        print("An error occurred")
    }
}

struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask(user: User(), task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "", isCompleted: false, tags: [], duration: 0, hourOffset: 0), isNewTask: false)
            .preferredColorScheme(.dark)
    }
}
