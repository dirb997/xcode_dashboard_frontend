//
//  APIService.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/07.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3000"
    
    func signUp(email: String, password: String, username: String, gender: String, role: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "username": username,
            "gender": gender,
            "role": role
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let userId = json["userId"] as? Int64 {
                        completion(.success(userId))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to signUp"])))
                    }
                }
            }
        }.resume()
    }
        
        
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let userData = json["user"] as? [String: Any] {
                        let user = User(
                            id: userData["id"] as? Int ?? 0,
                            email: userData["email"] as? String ?? "",
                            password: userData["password"] as? String ?? "",
                            username: userData["username"] as? String ?? "",
                            gender: userData["gender"] as? String ?? "",
                            role: userData["role"] as? String ?? ""
                        )
                        completion(.success(user))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to login"])))
                    }
                }
            }
        }.resume()
    }
}
