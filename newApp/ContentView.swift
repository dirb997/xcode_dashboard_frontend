//
//  ContentView.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(.testLogo).resizable().scaledToFit().frame(width: 200, height: 200)
                Image("SignUp")
                
                NavigationLink {
                    LoginView()
                } label: {
                    Image("Login-PNG").resizable().scaledToFit().frame(width: 100, height: 100)
                }
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Image("SingIn-JPG")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
        }
        .padding()
    }
}

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        Text("Login Page").font(.largeTitle).padding(.bottom, 20)
        
        TextField("Username", text: $username).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
        
        TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
        
        Button(action: {
            print("Logging in \(username) with \(password)")
        }) {
            Text("Login")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct SignUpView: View {
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var gender: String = "Male"
    
    let genders = ["Male", "Female", "Other"]
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up").font(.largeTitle).navigationTitle(Text("Sign up")) .padding(.bottom, 20)
            
            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Username", text: $username).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Confirm Password", text: $confirmPassword).textFieldStyle(RoundedBorderTextFieldStyle())
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Gender:").font(.headline)
                
                Picker("Gender", selection: $gender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            
            Button(action: {
                print("Signing up with email: \(email), password: \(password), username: \(username), gender: \(gender)")
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
