//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by António Loureiro on 04/03/2024.
//

import UIKit

class NetworkManager {

    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()

    private init() {

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

//    //using completion handler - old way
//    func getFollowers(username: String, page: Int, completed: @escaping (Result<[Follower], GHFError>) -> Void) {
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.invalidUsername))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let _ = error {
//                completed(.failure(.unableToComplete))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                completed(.success(followers))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//
//        task.resume()
//    }

    //using async/await - new way
    func getFollowers(username: String, page: Int) async throws -> [Follower] {

        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {

            throw GHFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHFError.invalidResponse
        }

        do {

            return try self.decoder.decode([Follower].self, from: data)

        } catch {

            throw GHFError.invalidData
        }
    }

    func getUserInfo(username: String) async throws -> User {

        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {

            throw GHFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

            throw GHFError.invalidResponse
        }

        do {

            return try self.decoder.decode(User.self, from: data)
        } catch {

            throw GHFError.invalidData
        }
    }

    //old way - using completion handler
//    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
//
//        let cacheKey = NSString(string: urlString)
//
//        //se a imagem que vou fazer o download for igual à imagem que já tenho na cache então saio (return)
//        if let image = cache.object(forKey: cacheKey) {
//
//            completed(image)
//            return
//        }
//
//        guard let url = URL(string: urlString) else {
//
//            completed(nil)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//
//            guard let self = self,
//                  error == nil,
//                  let response = response as? HTTPURLResponse, response.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//
//                completed(nil)
//                return
//            }
//
//            //aqui como já fiz o download da imagem vou então dar set à cache da imagem que fiz o download
//            self.cache.setObject(image, forKey: cacheKey)
//
//            //se alguma coisa falhar nesta network call faço return e saio
//            //se tudo Ok então como já tenho a image, de seguida vou setar a avatarImage com esta image
//            //como vou fazer um update à UI (e estou numa background thread) tenho que ir para a main thread
//
//            DispatchQueue.main.async {
//
//                completed(image)
//            }
//        }
//
//        task.resume()
//    }

    func downloadImage(from urlString: String) async -> UIImage? {
        
        //nao tem throws pois não quero saber de erro, se der erro então retorna um nil que é um placeholder
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else {

            return nil
        }

        do {

            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {

                return nil
            }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {

            return nil
        }
    }
}
