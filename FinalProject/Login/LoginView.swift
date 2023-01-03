//
//  LoginView.swift
//  FinalProject
//
//  Created by li on 2023/1/2.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @State var username = ""
    @State var email = ""
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Section {
            TextField("Username",text: $username)
            TextField("Email",text: $email)
        }
    }
    
    func login(){
    let url = URL(string: "https://favqs.com/api/users")!
    var request = URLRequest(url: url)
    request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token = 0053bc6a6fa7676be60e7b6edc9bac5c",forHTTPHeaderField:
    "Authorization")
        let User = CreateUser(user:[ userInfo(login: "\(username)", email: "\(email)", password: "1234")])
        let data = try? JSONEncoder().encode(User)
        request.httpBody = data
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let data = data{
                do{
                    let dic = try JSONDecoder().decode([String : Int].self, from : data)
                    print(dic)
                }catch{
                    print("error")
                }
            }
        
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

