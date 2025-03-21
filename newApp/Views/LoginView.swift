import SwiftUI


struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var rememberUser: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var loggedInUser: User? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none) 
                .padding(.horizontal)
            
            Button(action: {
                rememberUser.toggle()
            }) {
                HStack {
                    Image(systemName: rememberUser ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(rememberUser ? .blue : .gray)
                    
                    Text("Remember Me")
                }
            }
            .padding()
            
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
        APIService.shared.login(username: username, password: password) { result in
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
