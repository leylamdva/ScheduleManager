//
//  WeatherView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

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

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(user: User(), locationManager: LocationManager(), weatherResponse: WeatherResponse(weather: "Rainy", temp: 100.0), cityName: CityName(name: "Example", country: "Example"))
            .preferredColorScheme(.dark)
    }
}
