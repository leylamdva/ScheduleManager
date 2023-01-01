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
    
    var body: some View {
        TabView{
            HomeView(user: user)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            CalendarView()
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
