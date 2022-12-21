//
//  AccountView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                // Account information
                HStack{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                    Spacer()
                    Text("ExampleEmail/@gmail.com")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                Divider()
                    .frame(minHeight: 1)
                    .background(Color.gray)
                    .padding(.horizontal)
                
                // Location
                HStack {
                    NavigationLink(destination: Text("Location View"), label: {
                        Text("Location")
                            .font(.title3)
                    })
                        .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(20)
                
                // TODO: Separate the modifier and stacks
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
                Button{
                    // TODO: reset password implementation
                }label: {
                    Text("Reset Password")
                        .underline()
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                
                Spacer()
                
                // Log Out
                Button{
                    // TODO: logout implementation
                }label: {
                    Text("Log Out")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 20)
                // TODO: fix alignment
                .padding(.horizontal, 180)
                
            } //VStack
            .preferredColorScheme(.dark)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .preferredColorScheme(.dark)
    }
}
