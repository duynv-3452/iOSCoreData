//
//  APICaller.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    private init() {}
    func getFollower(username: String, page: Int, completion: @escaping(Result<[Follower], GHFError>) -> Void) {
        let url = "\(Urls.baseUrl)\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUsername))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
}

//func getFollowers(username: String, page: Int, completion: @escaping (Result<[FollowerModel], GHFError>) -> Void) {
//    let endPoint = "\(APIConstants.baseUrl)\(username)/followers?per_page=100&page=\(page)"
//    
//    guard let url = URL(string: endPoint) else {
//        completion(.failure(.invalidUsername))
//        return
//    }
//    
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let _ = error {
//            completion(.failure(.unableToComplete))
//            return
//        }
//        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            completion(.failure(.invalidResponse))
//            return
//        }
//        
//        guard let data = data else {
//            completion(.failure(.invalidData))
//            return
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            let followers = try decoder.decode([FollowerModel].self, from: data)
//            completion(.success(followers))
//        } catch {
//            completion(.failure(.invalidData))
//        }
//    }
//    
//    task.resume()
//}
