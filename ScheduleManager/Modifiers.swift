//
//  Modifiers.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 1/10/23.
//

import SwiftUI

struct MenuText : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct FieldBackgroundView : ViewModifier {
    var fieldColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(fieldColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.vertical, 10)
    }
}

struct InputField : ViewModifier {
    var fieldColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(fieldColor)
            .cornerRadius(15)
            .padding(.bottom, 5)
            .autocapitalization(.none)
    }
}
