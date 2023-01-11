//
//  AccountView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var user: User
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    // Account information
                    HStack{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Spacer()
                        Text(user.email)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    .padding(.horizontal, 30)
                    Divider()
                        .frame(minHeight: 1)
                        .background(Color.gray)
                        .padding(.horizontal)
                    
                    // TODO: Implement manual location selection
                    // Location
                    NavigationLink(destination: Text("Location View"), label: {
                        HStack {
                            Text("Location")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    })
                        .buttonStyle(PlainButtonStyle())
                        
                    .padding(20)
                    
                    // Clear all data
                    Button{
                        // TODO: clear data implementation
                    }label: {
                        Text("Clear all data")
                            .underline()
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    
                    // Reset Password
                    NavigationLink(destination: ForgotPassword(email: user.email), label: {
                        Text("Reset Password")
                            .underline()
                            .foregroundColor(.red)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    
                    
                    
                } //VStack for top
                Spacer()
                
                // Log Out
                Button{
                    // TODO: logout implementation
                    user.email = ""
                    user.password = ""
                    user.token = ""
                    user.location = ""
                    isAuthenticated = false
                }label: {
                    Text("Log Out")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 20)
                
            } //VStack
            .preferredColorScheme(.dark)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(user: User(), isAuthenticated: .constant(true))
            .preferredColorScheme(.dark)
    }
}
