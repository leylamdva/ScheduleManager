//
//  TimeLineView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct TimeLineView: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.gray)
            VStack{
                Divider()
                    .frame(height:1)
                    .background(Color.gray)
            }
        }
        .frame(height: 24)
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView(text: "9PM")
            .preferredColorScheme(.dark)
    }
}
