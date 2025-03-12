import Foundation
import UIKit

struct User: Codable {
    let id: Int
    let email: String
    let password: String
    let username: String
    let gender: String
    let role: String
    
    var profilePicture: UIImage? {
        return loadImageFromUserDefaults(key: "profileImage_\(username)")
    }
}
