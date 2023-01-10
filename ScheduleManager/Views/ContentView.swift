//
//  ContentView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var user: User
    @Binding var isAuthenticated: Bool
    @ObservedObject var tasksViewModel = TasksViewModel()
    @ObservedObject var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        TabView{
            HomeView(user: user, tasksViewModel: tasksViewModel, weatherViewModel: weatherViewModel)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            CalendarView(user: user)
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }
            AccountView(user: user, isAuthenticated: $isAuthenticated)
                .tabItem{
                    Label("Account", systemImage: "person.circle")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: User(), isAuthenticated: .constant(true))
            .preferredColorScheme(.dark)
    }
}
