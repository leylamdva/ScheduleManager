//
//  HomeView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI
import CoreLocation
import Foundation

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var user: User
    @ObservedObject var tasksViewModel: TasksViewModel
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    @State var start_time = Date.distantFuture
    @State var end_time = Date.distantPast
    @State var hasTimeSensitive = false
    @State var hasNonTimeSensitive = false
    
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    let today: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date.now)) ?? Date.now
    
    var body: some View {
        NavigationView {
            VStack{
                // Weather
                WeatherView(user: user, locationManager: locationManager, weatherResponse: weatherViewModel.weatherResponse, cityName: weatherViewModel.cityName)
                
                //Today's Date
                TodayView()
                
                // Tasks timeline (if any)
                ScrollView {
                    if hasTimeSensitive {
                        
                        ZStack {
                            TimelineGrid(today: today, start_time: start_time, end_time: end_time)
                            
                            HStack {
                                ForEach(tasksViewModel.tasks, id: \.self) { task in
                                    if task.isTimeSensitive {
                                        let offset = max(task.hourOffset - Double(start_time.hour), 0)
                                        
                                        NavigationLink(destination: CreateTask(user: user, task: task, isNewTask: false), label: {
                                            VStack (spacing: 0) {
                                                let backgroundColor: Color = task.tags.isEmpty ? .blue : Color(red: task.tags[0].color.red, green: task.tags[0].color.green, blue: task.tags[0].color.blue)
                                                Spacer()
                                                    .frame(height: 14 + 32 * offset)
                                                Text(task.name).bold()
                                                    .frame(width: 100, height: 32 * (task.duration + 3))
                                                    .background(RoundedRectangle(cornerRadius: 7).fill(backgroundColor))
                                                Spacer()
                                            }
                                        })
                                        .buttonStyle(PlainButtonStyle())
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
                    if hasNonTimeSensitive {
                        TaskChecklist(tasks: tasksViewModel.tasks, user: user)
                    } else {
                        Text("No other tasks for the day")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    
                } //ScrollView
                Spacer()
                
                // Plus for adding tasks
                AddTaskButtonView(user: user)
                
            } //VStack
            .navigationBarBackButtonHidden(true)
        } //Navigation view
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .task {
            await setUp()
        } //task
        .refreshable {
            await setUp()
        }
    }
    
    func setUp() async {
        
        // Tasks Setup
        await tasksViewModel.sendQuery(date: DateFormatter.iso8601.string(from: Date.now), token: user.token)
        
        for task in tasksViewModel.tasks{
            if task.isTimeSensitive {
                hasTimeSensitive = true
            } else {
                hasNonTimeSensitive = true
            }
        }
        
        (start_time, end_time) = setStartAndEndTime(tasks: tasksViewModel.tasks, start_time: start_time, end_time: end_time)
        
        //Weather Setup
        //If location is allowed
        if (locationManager.statusString == "authorizedWhenInUse" || locationManager.statusString == "authorizedAlways") {
            
            await weatherViewModel.getWeatherCoord(locationManager: locationManager, user: user)
            
            if (user.location == "") {
                await weatherViewModel.getLocationName(locationManager: locationManager, user: user)
                user.location = weatherViewModel.cityName.name
            }
            
        }
          
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User(), tasksViewModel: TasksViewModel(), weatherViewModel: WeatherViewModel())
            .preferredColorScheme(.dark)
    }
}
