import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3000"
//    private let baseURL = "http://192.168.0.30:3000"

    
    func signUp(email: String, password: String, username: String, gender: String, role: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/signup")!
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
        print("Sending Sign-Up Request: \(body)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            if let error = error {
                print("Sign-Up Response Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Sign-Up Response: \(json)")
                    if let userId = json["userId"] as? Int64 {
                        completion(.success(userId))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to signUp"])))
                    }
                }
            }
        }.resume()
    }
        
        
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
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
    
    func deleteAccount(userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/delete")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete account"])))
            }
        }.resume()
    }
}
