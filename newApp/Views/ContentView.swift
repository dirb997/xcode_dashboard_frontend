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
                Text("Welcome to Test App!")
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

#Preview {
    NavigationStack {
        ContentView()
    }
}
