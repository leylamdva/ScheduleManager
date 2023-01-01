//
//  CreateAccount.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/23/22.
//

import SwiftUI

struct CreateAccount: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    
    @StateObject var user: User = User()
    @Binding var authenticated: Bool
    @Binding var userData: Data
    @State private var showAlert = false
    @State private var alertType = ""
    @State var repeatedPassword = ""
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Email", text: $user.email)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $user.password)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.default)
                
                SecureField("Verify password", text: $repeatedPassword)
                    .modifier(InputField(fieldColor: fieldColor))
                    .keyboardType(.default)
                    
                // Warning if passwords do not match
                if repeatedPassword != "" && user.password != repeatedPassword {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                }
                
                // Submit button
                NavigationLink(destination: ContentView(user: user, isAuthenticated: $authenticated), isActive: $authenticated) {
                    
                    Button(action: {
                       // TODO: Implement POST registration request (only if passwords match)
                        if user.email == "" || user.password == "" || repeatedPassword == "" {
                            alertType = "blank"
                            showAlert = true
                        } else if repeatedPassword != user.password {
                            alertType = "match"
                            showAlert = true
                        } else {
                            Task{
                                await onSubmitPressed()
                            }
                        }
                        
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
                }
                
                Spacer()
                
            }
            .navigationTitle("Create an Account")
            .navigationBarTitleDisplayMode(.inline)
        } //Navigation View
        .padding(.horizontal, 15)
        .alert("Error", isPresented: $showAlert){
            Button("Close", role: .cancel){ }
        } message: {
            switch(alertType){
            case "match":
                Text("Entered passwords do not match")
            case "account":
                Text("An account with this email already exists")
            case "blank":
                Text("Email and password cannot be blank")
            default:
                Text("An unknown error occurred")
            }
        }
    }
    
    func onSubmitPressed() async{
        let url = RequestBase().url + "/api/User/register"
        
        let bodyObject : [String: Any] = [
            "name" : "a",
            "eMail" : user.email,
            "password" : user.password
        ]
            let body = try! JSONSerialization.data(withJSONObject: bodyObject)
            
        let (data, status) = await API().sendPostRequest(requestUrl: url, requestBodyComponents: body, token: "")
            print(String(decoding: data, as: UTF8.self))
            
            do {
                // If gives an error, decode the error message
                if status == 400 {
                    let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
                    if decodedMessage.message == "Mail '\(user.email)' is already taken" {
                        alertType = "account"
                        showAlert = true
                    }
                }else if status == 200{
                    let decodedToken = try JSONDecoder().decode(Token.self, from: data)
                    user.token = decodedToken.token
                    authenticated = true
                    
                    // Save user data
                    if let encodedData = try?JSONEncoder().encode(user){
                        userData = encodedData
                    }
                    
                }else{
                    showAlert = true
                }
            } catch {
                print(error)
            }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount(authenticated: .constant(false), userData: .constant(Data()))
            .preferredColorScheme(.dark)
    }
}
