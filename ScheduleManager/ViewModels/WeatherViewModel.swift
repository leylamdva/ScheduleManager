//
//  WeatherViewModel.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

@MainActor
class WeatherViewModel : ObservableObject {
    @Published var weatherResponse: WeatherResponse = WeatherResponse(weather: "", temp: 0.0)
    @Published var cityName: CityName = CityName(name: "", country: "")
    
    func getWeatherCoord(locationManager: LocationManager, user: User) async {
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
    
    func getLocationName(locationManager: LocationManager, user: User) async {
        let url = RequestBase().url + "/Weather/city_name?lat=\(locationManager.lastLocation?.coordinate.latitude ?? 0)&lon=\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        
        let (data, status) = await API().sendGetRequest(requestUrl: url, token: user.token)
        print(String(decoding: data, as: UTF8.self))
        
        //print("Code: \(status)")
        if !data.isEmpty && status == 200{
            do {
                cityName = try JSONDecoder().decode(CityName.self, from: data)
                //user.location = cityName.name
            }catch {
                print(error)
            }
        } else {
            print("An error occurred")
        }
    }
}
