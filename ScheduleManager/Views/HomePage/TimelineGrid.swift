//
//  TimeLineGrid.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

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

struct TimelineGrid_Previews: PreviewProvider {
    static var previews: some View {
        TimelineGrid(today: Date.now, start_time: Date.now, end_time: Date.now)
            .preferredColorScheme(.dark)
    }
}
