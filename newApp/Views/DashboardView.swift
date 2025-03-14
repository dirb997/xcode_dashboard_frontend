import SwiftUI

struct DashboardView: View {
    let user: User
    @State private var isLoggingOut = false
    @State private var showLogoutConfirmation: Bool = false
    @State private var showEditProfile: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var searchText: String = ""
    @State private var searchResults: [User] = []
    @State private var connectedUsers: [User] = []
    @State private var showSettings: Bool = false
    @State private var invitations: [User] = []
    @State private var showManageUsers: Bool = false
    @State private var isDeletingAccount: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 15) {
                    if let profileImage = user.profilePicture {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    }
                    
                    Text("Welcome, \(user.username)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Group {
                        Text("Email: \(user.email)")
                        Text("Role: \(user.role)")
                        Text("Gender: \(user.gender)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Text("Edit Profile")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 5)
                    
                    Divider()
                        .padding(.vertical)
                }
                .padding(.horizontal)
                
                // Role-specific content
                ScrollView {
                    switch user.role.lowercased() {
                    case "basic":
                        basicUserContent
//                    case "premium":
//                        premiumUserContent
//                    case "admin":
//                        adminUserContent
                    default:
                        Text("Unknown role type")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Bottom buttons
                HStack {
                    if user.role.lowercased() == "admin" {
                        Button(action: {
                            showSettings = true
                        }) {
                            Text("Settings")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Text("Delete Account")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
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
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
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
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
            .sheet(isPresented: $showEditProfile) {
                Text("Edit Profile View")
            }
            .sheet(isPresented: $showSettings) {
                Text("Settings View")
            }
            .sheet(isPresented: $showManageUsers) {
                Text("Manage Users View")
            }
        }
    }
    
    private func deleteAccount() {
        isDeletingAccount = true
        APIService.shared.deleteAccount(userId: user.id) { result in
            isDeletingAccount = false
            
            switch result {
            case .success:
                UserDefaults.standard.removeObject(forKey: "userToken")
                dismiss()
            case .failure(let error):
                print("Error deleting account: \(error)")
            }
        }
    }
    
    // TODO: - Basic User Content
    private var basicUserContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Search Users")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search basic users", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Button(action: searchUsers) {
                        Text("Search")
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                if !searchResults.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(searchResults, id: \.id) { user in
                                VStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                    
                                    Text(user.username)
                                        .font(.caption)
                                    
                                    Button(action: {
                                        sendInvitation(to: user)
                                    }) {
                                        Text("Add")
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                            .font(.caption)
                                    }
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .frame(height: 120)
                }
            }
            
            if !invitations.isEmpty {
                VStack(alignment: .leading) {
                    Text("Invitations")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(invitations, id: \.id) { user in
                                VStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                    
                                    Text(user.username)
                                        .font(.caption)
                                    
                                    HStack {
                                        Button(action: {
                                            acceptInvitation(from: user)
                                        }) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                        
                                        Button(action: {
                                            rejectInvitation(from: user)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .frame(height: 120)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Connected Users")
                    .font(.headline)
                
                if connectedUsers.isEmpty {
                    Text("You haven't connected with any users yet.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(connectedUsers, id: \.id) { user in
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                    
                                    VStack(alignment: .leading) {
                                        Text(user.username)
                                            .font(.headline)
                                        Text(user.email)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        removeConnection(user: user)
                                    }) {
                                        Image(systemName: "person.badge.minus")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
    }
    
    // TODO: - Connection Management Functions

    func removeConnection(user: User) {
        // TEST CODE
        if let index = connectedUsers.firstIndex(where: { $0.id == user.id }) {
            connectedUsers.remove(at: index)
            
        }
    }

    func acceptInvitation(from user: User) {
        // TEST CODE
        connectedUsers.append(user)

        if let index = invitations.firstIndex(where: { $0.id == user.id }) {
            invitations.remove(at: index)
        }
    }

    func rejectInvitation(from user: User) {
        // TEST CODE
        if let index = invitations.firstIndex(where: { $0.id == user.id }) {
            invitations.remove(at: index)
        }
    }

    func searchUsers() {
        // TEST CODE
        
        if !searchText.isEmpty {
            if user.role.lowercased() == "basic" {
                searchResults = [
                    User(id: 101, email: "user1@example.com", password: "", username: "basicUser1", gender: "Male", role: "basic"),
                    User(id: 102, email: "user2@example.com", password: "", username: "basicUser2", gender: "Female", role: "basic")
                ]
            } else if user.role.lowercased() == "premium" {
                searchResults = [
                    User(id: 101, email: "user1@example.com", password: "", username: "basicUser1", gender: "Male", role: "basic"),
                    User(id: 201, email: "premium1@example.com", password: "", username: "premiumUser1", gender: "Female", role: "premium"),
                    User(id: 301, email: "admin1@example.com", password: "", username: "adminUser1", gender: "Male", role: "admin")
                ]
            } else if user.role.lowercased() == "admin" {
                searchResults = [
                    User(id: 101, email: "user1@example.com", password: "", username: "basicUser1", gender: "Male", role: "basic"),
                    User(id: 201, email: "premium1@example.com", password: "", username: "premiumUser1", gender: "Female", role: "premium"),
                    User(id: 301, email: "admin1@example.com", password: "", username: "adminUser1", gender: "Male", role: "admin")
                ]
            }
        } else {
            searchResults = []
        }
    }

    func sendInvitation(to user: User) {
        // TEST CODE
        print("Invitation sent to \(user.username)")
    }
}
