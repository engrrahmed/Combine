//
//  FindUserModel.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 02/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import Foundation

struct UserFoundModel:Codable {
    var stat    : String?
    var code    : Int?
    var message : String?
}

// MARK: - UserModel
struct UserModel: Codable {
    var user: User?
    var stat: String?
}

// MARK: - User
struct User: Codable {
    var id, nsid: String?
    var username: Username?
}

// MARK: - Username
struct Username: Codable {
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
