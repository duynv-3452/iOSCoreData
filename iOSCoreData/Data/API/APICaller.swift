//
//  APICaller.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import Foundation
import UIKit

class APICaller {
    static let shared = APICaller()
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    func getFollower(username: String, page: Int, completion: @escaping(Result<[Follower], GHFError>) -> Void) {
        let url = "\(EndPointURL.BASE_URL)\(username)/followers?per_page=100&page=\(page)"
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
    
    func getUserInfo(username: String, completion: @escaping (Result<User, GHFError>) -> Void) {
        let url = "\(EndPointURL.BASE_URL)\(username)"
        guard let url = URL(string: url) else{
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
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self , error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
}
