//
//  DisabledOptionView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct DisabledOptionView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .modifier(MenuText())
            .foregroundColor(.gray)
        Spacer()
        Text("None")
            .fontWeight(.bold)
            .font(.title3)
            .foregroundColor(.gray)
    }
}

struct DisabledOptionView_Previews: PreviewProvider {
    static var previews: some View {
        DisabledOptionView(title: "Example")
            .preferredColorScheme(.dark)
    }
}
