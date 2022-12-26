//
//  CreateAccount.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/23/22.
//

import SwiftUI

struct CreateAccount: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    
    @State var email = ""
    @State var password = ""
    @State var repeatedPassword = ""
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Email", text: $email)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.default)
                
                SecureField("Verify password", text: $repeatedPassword)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.default)
                    
                // Warning if passwords do not match
                if repeatedPassword != "" {
                    if password != repeatedPassword {
                        Text("Passwords do not match")
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: {
                   // TODO: Implement POST registration request (only if passwords match)
                }){
                    Text("Submit")
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
            .navigationTitle("Create an Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
            .preferredColorScheme(.dark)
    }
}
