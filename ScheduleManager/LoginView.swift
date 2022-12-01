//
//  LoginView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView{
            Text("Hello")
        }
        .navigationBarTitle("Login", displayMode: .inline)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
