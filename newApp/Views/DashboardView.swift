import SwiftUI

struct DashboardView: View {
    let user: User
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
                print("Logging out")
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
