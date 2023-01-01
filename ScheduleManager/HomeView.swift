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
    
    @State private var tasks = [UserTask(name: "Tennis", timeSensitive: true, start_time: Date.now, end_time: Date.init(timeIntervalSinceNow: 120 * 60), recurring: "true", weather: "sunny", tags: []), UserTask(name: "Classes", timeSensitive: true, start_time: Date.init(timeIntervalSinceNow: 8000), end_time: Date.init(timeIntervalSinceNow: 8000 + 180 * 60), recurring: "", weather: "", tags: []), UserTask(name: "Draw", timeSensitive: false, start_time: Date.now, end_time: Date.now, recurring: "Never", weather: "None", tags: [])]
    
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
                            ForEach(tasks, id: \.self) { task in
                                if task.timeSensitive {
//                                    let duration = min(task.end_time.timeIntervalSince(task.start_time) / 3600,
//                                                       end_time.timeIntervalSince(task.start_time) / 3600,
//                                                       end_time.timeIntervalSince(start_time) / 3600)
                                    //var position = task.start_time.timeIntervalSince(start_time) / 3600
                                    VStack (spacing: 0) {
                                        Spacer()
                                            .frame(height: 14 + 32 * 0)
                                        Text(task.name).bold()
                                            .frame(width: 100, height: 32 * 1)
                                        // TODO: fix color (color of first tag or default color)
                                            .background(RoundedRectangle(cornerRadius: 7).fill(.blue))
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
                //TODO: Add no task available text
                TaskChecklist(tasks: tasks)
            } //ScrollView
            Spacer()
            
        } //VStack
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .onAppear(perform: {
            for task in tasks{
                if task.start_time < start_time {
                    start_time = task.start_time
                    start_time = start_time.roundDown()!
                }
                
                if task.end_time > end_time {
                    end_time = task.end_time
                    end_time = end_time.roundUp()!
                }
                
                if task.timeSensitive {
                    hasTimeSensitive = true
                }
            }
        })
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
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Other")
                .fontWeight(.bold)
                .font(.title)
            ForEach(tasks, id: \.self) { task in
                if !task.timeSensitive {
                    CheckboxTaskRow(task: task)
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
