//
//  User.swift
//  newApp
//
//  Created by Diego Berlanga on 2025/03/07.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let password: String
    let username: String
    let gender: String
    let role: String
}
