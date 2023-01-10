//
//  RepeatView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct RepeatView: View {
    @Binding var repeatTime: String
    @Binding var selectedDays: [Bool]
    var repeatTimes: [String]
    var fieldColor: Color
    var days: [String]
    
    var body: some View {
        VStack {
            HStack{
                Text("Repeat")
                    .modifier(MenuText())
                Spacer()
                Picker("", selection: $repeatTime){
                    ForEach(repeatTimes, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
            } //HStack Repeat
            .modifier(FieldBackgroundView(fieldColor: fieldColor))
            
            // Custom day selection
            if repeatTime == "Custom" {
                // TODO: fix spacing
                HStack {
                    ForEach(0..<7){i in
                        Button(action: {
                            selectedDays[i].toggle()
                        }) {
                            Text(days[i])
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 15)
                                .background(Circle().fill(selectedDays[i] ? .orange : fieldColor))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } // HStack
                .padding(15)
            }
        }
    }
}
struct RepeatView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatView(repeatTime: .constant(""), selectedDays: .constant([]), repeatTimes: [], fieldColor: .gray, days: [])
            .preferredColorScheme(.dark)
    }
}
