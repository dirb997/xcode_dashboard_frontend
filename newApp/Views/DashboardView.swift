import SwiftUI

struct DashboardView: View {
    let user: User
    @State private var isLoggingOut = false
    @State private var showLogoutProcess = false
    @Environment(\.dismiss) private var dismiss
    @State private var showLogoutConfirmation: Bool = false
    
    var body: some View {
        VStack {
            if let profileImage = user.profilePicture {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            }
            
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
