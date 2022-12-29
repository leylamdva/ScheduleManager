//
//  ScheduleManagerApp.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

@main
struct ScheduleManagerApp: App {
    @AppStorage("authenticated") var isAuthenticated: Bool = false
    @AppStorage("user") var userData: Data = Data()
    
    var body: some Scene {
        WindowGroup {
            HomeView(user: User())
//            if isAuthenticated{
//                if let user = try?JSONDecoder().decode(User.self, from: userData){
//                    ContentView(user: user, isAuthenticated: $isAuthenticated)
//                } else{
//                    // TODO: implement this
//                }
//            } else{
//                LoginView(authenticated: $isAuthenticated, userData: $userData)
//            }
        }
    }
}
