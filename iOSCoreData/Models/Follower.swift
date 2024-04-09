//
//  Follower.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

struct Follower: Codable {
    var login: String?
    var avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        login = try value.decodeIfPresent(String.self, forKey: .login)
        avatarUrl = try value.decodeIfPresent(String.self, forKey: .avatarUrl)
    }
}
