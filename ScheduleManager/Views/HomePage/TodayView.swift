//
//  TodayView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

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

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
