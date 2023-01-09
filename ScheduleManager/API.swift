//
//  API.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/1/23.
//

import Foundation

struct API {
    func sendPostRequest(requestUrl: String, requestBodyComponents: Data, token: String) async -> (Data, Int){
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = requestBodyComponents
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            print("Request failed.")
            print(error)
        }
        return (Data(), 0)
    }
    
    func sendGetRequest(requestUrl: String, token: String) async -> (Data, Int) {
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)
        
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            print(error)
        }
        return (Data(), 0)
    }
    
    func sendPutRequest(requestUrl: String, requestBodyComponents: Data, token: String) async -> (Data, Int) {
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.httpMethod = "PUT"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = requestBodyComponents
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            print(error)
        }
        return (Data(), 0)
    }
    
    func sendDeleteRequest(requestUrl: String, requestBodyComponents: Data, token: String) async -> (Data, Int) {
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = requestBodyComponents
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            print(error)
        }
        return (Data(), 0)
    }
}
