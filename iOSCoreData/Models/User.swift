//
//  User.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import Foundation

struct User {
    var login: String?
    var avatarUrl: String?
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int?
    var publicGists: Int?
    var htmlUrl: String?
    var following: Int?
    var followers: Int?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case location
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case htmlUrl = "html_url"
        case following
        case followers
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        login = try value.decodeIfPresent(String.self, forKey: .login)
        avatarUrl = try value.decodeIfPresent(String.self, forKey: .avatarUrl)
        name = try value.decodeIfPresent(String.self, forKey: .name)
        location = try value.decodeIfPresent(String.self, forKey: .location)
        bio = try value.decodeIfPresent(String.self, forKey: .bio)
        publicRepos = try value.decodeIfPresent(Int.self, forKey: .publicRepos)
        publicGists = try value.decodeIfPresent(Int.self, forKey: .publicGists)
        htmlUrl = try value.decodeIfPresent(String.self, forKey: .htmlUrl)
        following = try value.decodeIfPresent(Int.self, forKey: .following)
        followers = try value.decodeIfPresent(Int.self, forKey: .followers)
        createdAt = try value.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
