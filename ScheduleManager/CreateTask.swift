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
    @State var start_time = Date.now
    @State var end_time = Date.now
    @State private var showAlert = false
    @State private var showError = false
    @State private var processing = false
    @State var addedTags: [String] = []
    
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
            Task {
                processing = true
                await addTask()
                await syncTags()
            }
        } else {
            //TODO: update the task in the database
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
                    
                    // Repeat
                    VStack {
                        HStack{
                            Text("Repeat")
                                .modifier(MenuText())
                            Spacer()
                            Picker("", selection: $repeatTime){
                                ForEach(repeatTimes, id: \.self){
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .accentColor(.white)
                        } //HStack Repeat
                        .modifier(FieldBackgroundView(fieldColor: fieldColor))
                        
                        // Custom day selection
                        if repeatTime == "Custom" {
                            // TODO: fix spacing
                            HStack {
                                ForEach(0..<7){i in
                                    Button(action: {
                                        selectedDays[i].toggle()
                                    }) {
                                        Text(days[i])
                                            .fontWeight(.bold)
                                            .background(Circle().fill(selectedDays[i] ? .orange : fieldColor)
                                                .frame(width: 45, height: 45))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal, 9)
                                }
                            } // HStack
                            .padding(15)
                        }
                    } // VStack repeat
                    
                    // Tags Navigation View
                    NavigationLink(destination: CreateTagsView(task: $task, addedTags: $addedTags, token: user.token), label: {
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
                }//VStack
                
                if processing {
                    ProgressView()
                        .frame(width:250, height: 250)
                }
            } //ZStack

        }
        .padding(.horizontal, 15)
        .navigationBarBackButtonHidden(true)
        // TODO: Custom Cancel and Done button
        .navigationTitle("Create a Task")
        .navigationBarItems(leading: buttonCancel, trailing: buttonDone)
        .alert("Success", isPresented: $showAlert){
            Button("Done", role: .cancel){ self.presentationMode.wrappedValue.dismiss() }
        } message: {
            Text("The task has been successfully added")
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
                //processing = false
                //showAlert = true
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
}

struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask(user: User(), task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "", isCompleted: false, tags: []), isNewTask: false)
            .preferredColorScheme(.dark)
    }
}

struct InputField : ViewModifier {
    var fieldColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(fieldColor)
            .cornerRadius(15)
            .padding(.bottom, 5)
            .autocapitalization(.none)
    }
}

struct FieldBackgroundView : ViewModifier {
    var fieldColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(fieldColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.vertical, 10)
    }
}

struct MenuText : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct DividerView: View {
    var body: some View {
        Divider()
            .frame(minHeight: 1)
            .background(Color.gray)
            .padding(.horizontal, 15)
            .foregroundColor(.black)
    }
}

struct DisabledOptionView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .modifier(MenuText())
            .foregroundColor(.gray)
        Spacer()
        Text("None")
            .fontWeight(.bold)
            .font(.title3)
            .foregroundColor(.gray)
    }
}

func setDays(option: String) -> [Bool] {
    var selectedDays = [false, false, false, false, false, false, false]
    switch(option) {
    case "Everyday":
        selectedDays = [true, true, true, true, true, true, true]
    case "Weekends":
        selectedDays = [false, false, false, false, false, true, true]
    case "Weekdays":
        selectedDays = [true, true, true, true, true, false, false]
    default:
        return selectedDays
    }
    
    return selectedDays
}
