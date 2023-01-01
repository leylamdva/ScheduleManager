//
//  LoginView.swift
//  ScheduleManager
//
//  Created by Leyla Mammadova on 12/1/22.
//

import SwiftUI

struct RequestBase {
    var url: String = "https://schedules.azurewebsites.net"
}

struct LoginView: View {
    let fieldColor = Color(red: 0.168, green: 0.168, blue: 0.208)
    
    @StateObject var user: User = User()
    @Binding var authenticated: Bool
    @Binding var userData: Data
    @State private var showAlert = false
    
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
                    
                    NavigationLink(destination: ForgotPassword(email: user.email)){
                        Text("Forgot password?")
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                
                // Login button
                NavigationLink(destination: ContentView(user: user, isAuthenticated: $authenticated), isActive: $authenticated){
                    Button(action: {
                        Task{
                            await onLoginPressed()
                        }
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
                NavigationLink(destination: CreateAccount(authenticated: $authenticated, userData: $userData)){
                    Text("or Create an Account")
                        .foregroundColor(.blue)
                        .underline()
                }
                
                Spacer()
                
                
            }
            .navigationBarTitle("Login", displayMode: .inline)
        }
        .padding(.horizontal, 15)
        .alert("Error", isPresented: $showAlert){
            Button("Close", role: .cancel){ }
        } message: {
            Text("Incorrect e-mail or password")
        }
    }
    
    func onLoginPressed() async {
            
        let url = RequestBase().url + "/api/User/authenticate"
        
        let bodyObject : [String: Any] = [
            "eMail" : user.email,
            "password" : user.password
        ]
            let body = try! JSONSerialization.data(withJSONObject: bodyObject)
            
        let (data, status) = await API().sendPostRequest(requestUrl: url, requestBodyComponents: body, token: "")
            print(String(decoding: data, as: UTF8.self))
            
            do {
                if status == 200{
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
                //print("Login failed")
                print(error)
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authenticated: .constant(false), userData: .constant(Data()))
            .preferredColorScheme(.dark)
    }
}
