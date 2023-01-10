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
    
    @State var start_time = Date.distantFuture
    @State var end_time = Date.distantPast
    @State var hasTimeSensitive = false
    @State var hasNonTimeSensitive = false
    @State var weatherResponse = WeatherResponse(weather: "", temp: 0.00)
    @State var cityName = CityName(name: "", country: "")
    
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
                WeatherView(user: user, locationManager: locationManager, weatherResponse: weatherResponse, cityName: cityName)
                
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
                                        NavigationLink(destination: CreateTask(user: user, task: task, isNewTask: false), label: {
                                            VStack (spacing: 0) {
                                                let backgroundColor = task.tags.isEmpty ? .blue : Color(red: task.tags[0].color.red, green: task.tags[0].color.green, blue: task.tags[0].color.blue)
                                                Spacer()
                                                    .frame(height: 14 + 32 * 0)
                                                Text(task.name).bold()
                                                    .frame(width: 100, height: 32 * 1)
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
            } else {
                hasNonTimeSensitive = true
            }
        } //for loop
        
        //Weather Setup
        //If location is allowed
        if (locationManager.statusString == "authorizedWhenInUse" || locationManager.statusString == "authorizedAlways") {
            
            await getWeatherCoord()
            
            if (user.location == "") {
                await getLocationName()
            }
            
        }
          
    }
    
    func getWeatherCoord() async {
        let url = RequestBase().url + "/Weather/coords?lat=\(locationManager.lastLocation?.coordinate.latitude ?? 0)&lon=\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        
        //print(url)
        
        let (data, status) = await API().sendGetRequest(requestUrl: url, token: user.token)
        print(String(decoding: data, as: UTF8.self))
        //print("Code: \(status)")
        
        if !data.isEmpty && status == 200{
            do {
                weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                weatherResponse.temp = round(convertTemperature(temp: weatherResponse.temp, from: .kelvin, to: .celsius))
            }catch {
                print(error)
            }
        } else {
            print("An error occurred")
        }
    }
    
    func getLocationName() async {
        let url = RequestBase().url + "/Weather/city_name?lat=\(locationManager.lastLocation?.coordinate.latitude ?? 0)&lon=\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        
        let (data, status) = await API().sendGetRequest(requestUrl: url, token: user.token)
        print(String(decoding: data, as: UTF8.self))
        
        print("Code: \(status)")
        if !data.isEmpty && status == 200{
            do {
                cityName = try JSONDecoder().decode(CityName.self, from: data)
                user.location = cityName.name
            }catch {
                print(error)
            }
        } else {
            print("An error occurred")
        }
    }
}

func convertTemperature(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> Double {
    let input = Measurement(value: temp, unit: inputTempType)
    let output = input.converted(to: outputTempType)
    return output.value
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User(), tasksViewModel: TasksViewModel())
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
    var weatherResponse: WeatherResponse
    var cityName: CityName
    
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
                    if user.location != "" {
                        Text("\(user.location)")
                            .font(.title3)
                    } else {
                        Text("\(cityName.name)")
                            .font(.title3)
                    }
                    Spacer()
                    let tempString = String(format: "%.0f", weatherResponse.temp)
                    Text("\(tempString)°C")
                        .font(.title3)
                    WeatherIcon(weather: weatherResponse.weather)
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

struct TagsButtonView: View {
    var tags: [Tag]
    @Binding var selectedTag: String
    
    var body: some View {
        ForEach(tags, id: \.self) { tag in
            Button(action: {
                if selectedTag == tag.name {
                    selectedTag = ""
                }else {
                    selectedTag = tag.name
                }  
            }, label: {
                Text(tag.name).bold()
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 7).fill(Color(red: tag.color.red, green: tag.color.green, blue: tag.color.blue)))
            })
            .buttonStyle(PlainButtonStyle())
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
