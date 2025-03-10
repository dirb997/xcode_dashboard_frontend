import SwiftUI

struct DashboardView: View {
    let user: User
    @State private var isLoggingOut = false
    @State private var showLogoutProcess = false
    @Environment(\.dismiss) private var dismiss
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
            
            Button(action: {
                showLogoutProcess = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UserDefaults.standard.removeObject(forKey: "userToken")
                    showLogoutProcess = true
                    dismiss()
                }

            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Dashboard")
    }
}
