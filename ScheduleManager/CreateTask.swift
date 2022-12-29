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
    
    @State var name = ""
    @State var timeSensitive = false
    @State var startDate = Date.now
    @State var endDate = Date.now
    @State var repeatTime = "Never"
    @State var selectedDays = [false, false, false, false, false, false, false]
    @State var selectedWeather = "None"
    @State var task = Task(name: "", timeSensitive: true, start_time: Date.now, end_time: Date.now, recurring: "", weather: "", tags: [])
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                TextField("Name", text: $name)
                    .modifier(InputField(fieldColor: fieldColor))
                    .padding(.vertical, 10)
                
                //Time options
                VStack (alignment: .leading){
                    HStack{
                        Text("Time-Sensitive")
                            .modifier(MenuText())
                        Toggle("", isOn: $timeSensitive)
                    }
                    .padding(.horizontal, 20)
                    
                    DividerView()

                    // Start Time
                    HStack {
                        if timeSensitive{
                            Text("Start Time")
                                .modifier(MenuText())
                            DatePicker("", selection: $startDate)
                            // TODO: change time selection to store in database
                            //Text(DateFormatter.times.string(from: startDate))
                        } else{
                            DisabledOptionView(title: "Start Time")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    DividerView()
                    
                    // End Time
                    HStack {
                        if timeSensitive{
                            Text("End Time")
                                .modifier(MenuText())
                            DatePicker("", selection: $endDate)
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
                
                // Tags
                NavigationLink(destination: CreateTagsView(task: task), label: {
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
                    Picker("", selection: $selectedWeather){
                        ForEach(weather, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.white)
                } // HStack Weather
                .modifier(FieldBackgroundView(fieldColor: fieldColor))
                
                Spacer()
            } //VStack
            .navigationBarTitle(Text("Create a Task"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
            // TODO: Custom Cancel and Done button
            .navigationBarItems(leading: Text("Cancel"), trailing: Text("Done"))
        }
    }
}

struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask()
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
