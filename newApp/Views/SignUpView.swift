//
//  SignUpView.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/07.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var gender: String = "Male"
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var role: String = "Basic"
    @State private var isSignedUp = false
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    
    let genders = ["Male", "Female", "Other"]
    
    let roles = ["Admin", "Basic", "Prmeium"]
    
    var body: some View {
        VStack {
            VStack {
                if let profileImage = profileImage {
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
                
                Button("Select Photo") {
                    showImagePicker = true
                }
                .padding(.top, 8)
            }
            .padding(.bottom, 20)
        }
            
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none) 
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Gender:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Role:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                ForEach(0..<max(genders.count, roles.count), id: \.self) { index in
                    HStack {
                        if index < genders.count {
                            HStack {
                                Image(systemName: gender == genders[index] ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(gender == genders[index] ? .blue : .gray)
                                Text(genders[index])
                                    .foregroundColor(.primary)
                            }
                            .onTapGesture {
                                gender = genders[index]
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }
                        
                        if index < roles.count {
                            HStack {
                                Image(systemName: role == roles[index] ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(role == roles[index] ? .blue : .gray)
                                Text(roles[index])
                                    .foregroundColor(.primary)
                            }
                            .onTapGesture {
                                role = roles[index]
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Button(action: {
                if validateInputs() {
                    signUp()
                } else {
                    showError = true
                }
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Sign up")
        .navigationDestination(isPresented: $isSignedUp) {
            ContentView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
    
    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty || username.isEmpty {
            errorMessage = "Please fill in all fields."
            return false
        }
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }
    
    private func signUp() {
        APIService.shared.signUp(email: email, password: password, username: username, gender: gender, role: role) { result in
            switch result {
            case .success(let userId):
                print("Successfully signed up successfully with ID: \(userId)")
                self.isSignedUp = true
            case .failure(let error):
                print("Sign Up Failed: \(error.localizedDescription)")
                showError = true
            }
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
