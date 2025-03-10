//
//  LoginView.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/07.
//

import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loggedInUser: User? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none) 
                .padding(.horizontal)
            
            Button(action: {
                login()
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
        .navigationTitle("Login")
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationDestination(isPresented: $isLoggedIn) {
            if let user = loggedInUser {
                DashboardView(user: user)
            }
        }
    }
    
    private func login() {
        APIService.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let user):
                loggedInUser = user
                isLoggedIn = true
            case .failure(let error):
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

}
