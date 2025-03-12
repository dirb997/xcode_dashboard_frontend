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
                        Image("button_login").resizable().scaledToFit().frame(width: 100, height: 100)
                    }
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Image("button_sign-up")
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
