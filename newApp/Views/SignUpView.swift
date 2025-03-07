//
//  SignUpView.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/07.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var gender: String = "Male"
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var role: String = "Basic"
    
    let genders = ["Male", "Female", "Other"]
    
    let roles = ["Basic", "Premium", "Admin"]
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Gender")
                    .font(.headline)
                
                ForEach(genders, id: \.self) { option in
                    HStack {
                        Image(systemName: gender == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(gender == option ? .blue : .gray)
                        Text(option)
                            .foregroundColor(.primary)
                    }
                    .onTapGesture {
                        gender = option
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Role")
                    .font(.headline)
                
                ForEach(roles, id: \.self) { option in
                    HStack {
                        Image(systemName: role == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(role == option ? .blue : .gray)
                        Text(option)
                            .foregroundColor(.primary)
                    }
                    .onTapGesture {
                        role = option
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                if validateInputs() {
                    signUp()
                } else {
                    showError = true
                }
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
        .navigationTitle("Sign up")
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty || username.isEmpty {
            errorMessage = "Please fill in all fields."
            return false
        }
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }
    
    private func signUp() {
        APIService.shared.signUp(email: email, password: password, username: username, gender: gender, role: role) { result in
            switch result {
            case .success(let userId):
                print("Successfully signed up successfully with ID: \(userId)")
            case .failure(let error):
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
