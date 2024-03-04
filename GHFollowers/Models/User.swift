//
//  User.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/03/2024.
//

import Foundation

struct User: Codable {

    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var follwing: Int
    var follwers: Int
    var createdAt: String
}
