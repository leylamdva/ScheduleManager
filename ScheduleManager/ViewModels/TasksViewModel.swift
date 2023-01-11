//
//  TasksViewModel.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/1/23.
//

import SwiftUI

@MainActor
class TasksViewModel : ObservableObject {
    @Published var tasks: [UserTask] = []
    
    func sendQuery(date: String, token: String) async{
        let url = RequestBase().url + "/api/Tasks/dailyTasks/" + date
         
        let (data, status) = await API().sendGetRequest(requestUrl: url, token: token)
        print(String(decoding: data, as: UTF8.self))
        if !data.isEmpty && status == 200{
            decodeResponse(data: data)
        } else {
            print("An error occurred loading tasks")
        }
    }
    
    func decodeResponse(data: Data){
        do {
            tasks = try JSONDecoder().decode([UserTask].self, from: data)
        }catch {
            print(error)
        }
    }
}
