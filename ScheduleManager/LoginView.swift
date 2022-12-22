//
//  LoginView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct LoginView: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    
    @StateObject var user: User = User()
    @Binding var authenticated: Bool
    @Binding var userData: Data
    
    var body: some View {
        NavigationView{
            VStack{
                // Email field
                TextField("Email", text: $user.email)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.emailAddress)
                
                // Password field
                VStack(alignment: .leading) {
                    SecureField("Password", text: $user.password)
                        .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.default)
                    
                    NavigationLink(destination: Text("Forgot Password")){
                        Text("Forgot password?")
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                
                // Login button
                NavigationLink(destination: ContentView(), isActive: $authenticated){
                    Button(action: {
                       // TODO: Implement login
                    }){
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                
                // Create account
                NavigationLink(destination: Text("Create Account")){
                    Text("or Create an Account")
                        .foregroundColor(.blue)
                        .underline()
                }
                
                Spacer()
                
                
            }
            .navigationBarTitle("Login", displayMode: .inline)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authenticated: .constant(false), userData: .constant(Data()))
            .preferredColorScheme(.dark)
    }
}
