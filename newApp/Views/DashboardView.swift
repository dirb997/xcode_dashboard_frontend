import SwiftUI

struct DashboardView: View {
    let user: User
    @State private var isLoggingOut = false
    @State private var showLogoutProcess = false
    @Environment(\.dismiss) private var dismiss
    @State private var showLogoutConfirmation: Bool = false
    
    var body: some View {
        VStack {
            Text("Welcome, \(user.username)")
                .font(.largeTitle)
                .padding(.bottom, 20)

            Text("Email: \(user.email)")
                .padding(.bottom, 10)
            Text("Role: \(user.role)")
                .padding(.bottom, 10)
            Text("Gender: \(user.gender)")
                .padding(.bottom, 10)

            Spacer()
            
            if isLoggingOut {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Button(action: {
                    showLogoutConfirmation = true
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert("Logout", isPresented: $showLogoutConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Logout", role: .destructive) {
                        isLoggingOut = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            UserDefaults.standard.removeObject(forKey: "userToken")
                            dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to logout?")
                }
            }
        }
        .navigationTitle("Dashboard")
    }
}
