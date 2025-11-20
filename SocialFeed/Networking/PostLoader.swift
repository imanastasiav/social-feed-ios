//
//  IPostLoader.swift
//  SocialFeed
//
//  Created by Анастасия on 18.11.2025.
//

import Foundation
import UIKit

protocol IPostLoader {
    func loadPosts(completion: @escaping (Result<[Post], Error>) -> ())
}

final class PostLoader: IPostLoader {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.statusCode))
                }
                return
            }
            
            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
