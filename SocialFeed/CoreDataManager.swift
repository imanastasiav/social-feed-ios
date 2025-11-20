//
//  CoreManager.swift
//  SocialFeed
//
//  Created by Анастасия on 20.11.2025.
//

import Foundation

enum NetworkError: Error {
    case statusCode
    case noData
}

final class PostLoader {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func loadPosts(completion: @escaping (Result<[Post], Error>) -> Void) {

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        session.dataTask(with: url) { data, _, error in

            if error != nil {
                completion(.failure(NetworkError.statusCode))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let posts = try self.decoder.decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}

