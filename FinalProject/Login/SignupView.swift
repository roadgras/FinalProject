//
//  SignupView.swift
//  FinalProject
//
//  Created by li on 2023/1/2.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginData:Login
    @State var login:String=""
    @State var email:String=""
    @State var password:String=""
    @State private var showingAlert = false
    var textFieldBorder: some View {
           RoundedRectangle(cornerRadius: 20)
               .stroke(Color.gray, lineWidth: 2)
       }
    var body: some View {
        NavigationView {
            VStack{
                Text("Create account")
                    .font(.title)
                    .frame(height: 100, alignment: .center)
                TextField("user name",text: $login).padding()
                    .overlay(textFieldBorder)
                    .padding()
                TextField("email",text: $email).padding()
                    .overlay(textFieldBorder)
                    .padding()
                SecureField("password ( at least 5 characters)",text: $password).padding()
                    .overlay(textFieldBorder)
                    .padding()
                Button(action: {
                    let url = URL(string: "https://favqs.com/api/users")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token token=\"bdb45b3357e3021ceef7d1319ddd5b40\"", forHTTPHeaderField: "Authorization")
                    let encoder = JSONEncoder()
                    let user = CreatedUsersBody(user:CreatedUsers(login: login,email:email, password: password))
                    let data = try? encoder.encode(user)
                    request.httpBody = data
                    print("user=\(user)")
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data{
                            do{
                                let content = String(data: data, encoding: .utf8)
                                print("content=\(String(describing: content))")
                                let decoder = JSONDecoder()
                                let createdUsersResponse = try decoder.decode(CreatedUsersResponse.self, from: data)
                                print(createdUsersResponse)
                                loginData.token = createdUsersResponse.Token
                                loginData.login=createdUsersResponse.login
                            }catch{
                                print("ERROR")
                                print(error)
                                showingAlert = true
                            }
                        }
                    }.resume()
                }, label: {
                    Text("Sign Up")
                    })
                .frame(width: 100, height: 50, alignment: .center)
                
            }.offset(y: -150.0)
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

