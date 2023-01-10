//
//  ForgotPassword.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/23/22.
//

import SwiftUI

struct ForgotPassword: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    
    @State var code = ""
    var email: String
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Enter the verification code sent to the email \(email)")
                    .font(.title3)
                
                TextField("Verification code", text: $code)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.decimalPad)
                
                // Confirm button
                Button(action: {
                   // TODO: Implement authentication
                }){
                    Text("Confirm")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(email: "exampleEmail@gmail.com")
            .preferredColorScheme(.dark)
    }
}
