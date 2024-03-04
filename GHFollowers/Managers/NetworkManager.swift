//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/03/2024.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    let baseURL = "https://api.github.com"
    let perPageItems = 100

    private init() {

    }

    func getFollowers(username: String, page: Int, completion: @escaping ([Follower]?, ErrorMessage?) -> Void) {

        //([Follower]?, String?) são Optional pq se tivermos [Followers] não temos error,
        //e se tivermos String(error) então [Follower] é nil
        let endpoint = baseURL + "/users/\(username)/followers?per_page=\(perPageItems)&page=\(page)"

        guard let url = URL(string: endpoint) else {

            completion(nil, .invalidUsername)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error ) in

            if let _ = error {

                completion(nil, .unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

                completion(nil, .invalidResponse)
                return
            }

            guard let data = data else {

                completion(nil, .invalidData)
                return
            }

            do {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)

            } catch  {

                completion(nil, .invalidData)
            }
        }

        task.resume()
    }
}
