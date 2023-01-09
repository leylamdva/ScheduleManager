//
//  HomeView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var user: User
    @ObservedObject var tasksViewModel = TasksViewModel()
    
    @State var start_time = Date.distantFuture
    @State var end_time = Date.distantPast
    @State var hasTimeSensitive = false
    
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        NavigationView {
            VStack{
                // Weather
                WeatherView(user: user, locationManager: locationManager)
                
                //Today's Date
                TodayView()
                
                // Tasks timeline (if any)
                ScrollView {
                    if hasTimeSensitive {
                        let today = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date.now)) ?? Date.now
                        ZStack {
                            TimelineGrid(today: today, start_time: start_time, end_time: end_time)
                            
                            HStack {
                                // TODO: calculate task duration
                                // TODO: place tasks in the correct spot
                                ForEach(tasksViewModel.tasks, id: \.self) { task in
                                    if task.isTimeSensitive {
    //                                    let duration = min(task.end_time.timeIntervalSince(task.start_time) / 3600,
    //                                                       end_time.timeIntervalSince(task.start_time) / 3600,
    //                                                       end_time.timeIntervalSince(start_time) / 3600)
                                        //var position = task.start_time.timeIntervalSince(start_time) / 3600
                                        VStack (spacing: 0) {
                                            let backgroundColor = task.tags.isEmpty ? .blue : Color(red: task.tags[0].color.red, green: task.tags[0].color.green, blue: task.tags[0].color.blue)
                                            Spacer()
                                                .frame(height: 14 + 32 * 0)
                                            Text(task.name).bold()
                                                .frame(width: 100, height: 32 * 1)
                                                .background(RoundedRectangle(cornerRadius: 7).fill(backgroundColor))
                                            Spacer()
                                        }
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        Text("No time-sensitive tasks for today")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    
                    // The remaining tasks (Checklist)
                    TaskChecklist(tasks: tasksViewModel.tasks, user: user)
                } //ScrollView
                Spacer()
                
                // Plus for adding tasks
                HStack{
                    Spacer()
                    NavigationLink(destination: CreateTask(user: user, task: UserTask(id: "", name: "", isTimeSensitive: false, startDateTime: "", endDateTime: "", repeatDays: [], weatherRequirement: "None", isCompleted: false, tags: []), isNewTask: true), label: {
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
                
            } //VStack
            .navigationBarBackButtonHidden(true)
        } //Navigation view
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .task {
            await tasksViewModel.sendQuery(date: DateFormatter.iso8601.string(from: Date.now), token: user.token)
            
            for task in tasksViewModel.tasks{
                //print(task.startDateTime)
                let taskStartDateTime = DateFormatter.iso.date(from: task.startDateTime) ?? Date.now
                if taskStartDateTime != Date.now && taskStartDateTime < start_time {
                    start_time = DateFormatter.iso.date(from: task.startDateTime)!
                    start_time = start_time.roundDown()!
                }
                
                //print(task.endDateTime)
                let taskEndDateTime = DateFormatter.iso.date(from: task.endDateTime) ?? Date.now
                if taskEndDateTime != Date.now && taskEndDateTime > end_time {
                    end_time = DateFormatter.iso.date(from: task.endDateTime)!
                    end_time = end_time.roundUp()!
                }
                
                if task.isTimeSensitive {
                    hasTimeSensitive = true
                }
            }
        } //task
        .refreshable {
            await tasksViewModel.sendQuery(date: DateFormatter.iso8601.string(from: Date.now), token: user.token)
            
            for task in tasksViewModel.tasks{
                //print(task.startDateTime)
                let taskStartDateTime = DateFormatter.iso.date(from: task.startDateTime) ?? Date.now
                if taskStartDateTime != Date.now && taskStartDateTime < start_time {
                    start_time = DateFormatter.iso.date(from: task.startDateTime)!
                    start_time = start_time.roundDown()!
                }
                
                //print(task.endDateTime)
                let taskEndDateTime = DateFormatter.iso.date(from: task.endDateTime) ?? Date.now
                if taskEndDateTime != Date.now && taskEndDateTime > end_time {
                    end_time = DateFormatter.iso.date(from: task.endDateTime)!
                    end_time = end_time.roundUp()!
                }
                
                if task.isTimeSensitive {
                    hasTimeSensitive = true
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User())
            .preferredColorScheme(.dark)
    }
}

struct TimeLineView: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.gray)
            VStack{
                Divider()
                    .frame(height:1)
                    .background(Color.gray)
            }
        }
        .frame(height: 24)
    }
}

struct WeatherView: View {
    var user: User
    var locationManager: LocationManager
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue)
                .frame(height: 70)
                .frame(maxWidth: .infinity)
            // If location services are on or location is entered manually
            if (locationManager.statusString == "authorizedWhenInUse" || locationManager.statusString == "authorizedAlways" || user.location != "") {
                HStack {
                    Image(systemName: "location")
                    // TODO: Get city name
                    Text("\(user.location)")
                    Spacer()
                    // TODO: send request and display weather
                    Text("25")
                    // TODO: Function to display the right icon
                    Image(systemName: "sun.max")
                }
                .padding()
            } else {
                HStack {
                    Image(systemName: "location.slash")
                    Text("Location Unavailable")
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct TaskChecklist: View {
    var tasks: [UserTask]
    var user: User
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Other")
                .fontWeight(.bold)
                .font(.title)
            ForEach(tasks, id: \.self) { task in
                if !task.isTimeSensitive {
                    CheckboxTaskRow(task: task, user: user)
                }
            }
        }
    }
}

struct TodayView: View {
    var body: some View {
        HStack {
            Text("Today")
                .fontWeight(.bold)
                .font(.title)
            Spacer()
            Text(DateFormatter.day.string(from: Date.now))
                .fontWeight(.bold)
                .font(.title)
        }
    }
}

struct TimelineGrid: View {
    var today: Date
    var start_time: Date
    var end_time: Date
    
    var body: some View {
        VStack {
            if start_time != Date.distantFuture {
                let start_limit = max(Int(start_time.timeIntervalSince(today) / 3600), 0)
                let end_limit = min(Int(end_time.timeIntervalSince(today) / 3600), 24)
                ForEach(start_limit..<end_limit+1, id: \.self){ i in
                    TimeLineView(text: String(format: "%02d:00", i))
                }
            }
        }
    }
}
