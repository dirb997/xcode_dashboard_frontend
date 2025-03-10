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
                Image(.kazokuAppLogo).resizable().scaledToFit().frame(width: 275, height: 275)
                Text("Kazoku Appソーシャルへようこぞ！")
                Image("SignUp")
                HStack {
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
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
