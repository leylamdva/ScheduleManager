//
//  DividerView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Divider()
            .frame(minHeight: 1)
            .background(Color.gray)
            .padding(.horizontal, 15)
            .foregroundColor(.black)
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
            .preferredColorScheme(.dark)
    }
}
