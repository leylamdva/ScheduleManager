//
//  API.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/1/23.
//

import Foundation

struct API {
    func sendPostRequest(requestUrl: String, requestBodyComponents: Data) async -> (Data, Int){
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.httpMethod = "POST"
        request.httpBody = requestBodyComponents
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            print("Request failed.")
        }
        return (Data(), 0)
    }
    
    func sendGetRequest(requestUrl: String) async -> Data {
        let url = URL(string: requestUrl)!
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print(error)
        }
        return Data()
    }
}
